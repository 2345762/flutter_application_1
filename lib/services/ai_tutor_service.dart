import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_ai/firebase_ai.dart';

class AiTutorException implements Exception {
  final String message;
  final bool isRetryable;
  AiTutorException(this.message, {this.isRetryable = false});

  @override
  String toString() => 'AiTutorException: $message';
}

class AiTutorService {
  // Ordered candidate models: high intelligence first, then high speed / throughput fallback
  static const List<String> _candidateModels = [
    'gemini-3.7-flash',
    'gemini-3.5-flash',
    'gemini-3.5-flash-lite',
  ];

  static const int _maxOutputTokens = 2000;
  static const double _temperature = 0.5;
  static const int _maxDoubtLength = 500;
  static const int _maxQuestionLength = 1000;
  static const int _cooldownMs = 3000;

  // Retry configuration per model
  static const int _maxRetriesPerModel = 2;
  static const List<int> _retryDelaysMs = [800, 1600];

  DateTime? _lastRequestTime;

  /// Calls generative models with multi-model fallback chain and exponential backoff.
  Future<String> _callWithMultiModelFallback({
    required String userPrompt,
    required String systemInstruction,
  }) async {
    Object? lastError;


    for (int modelIndex = 0; modelIndex < _candidateModels.length; modelIndex++) {
      final modelName = _candidateModels[modelIndex];
      bool modelSucceeded = false;
      String? resultText;

      for (int attempt = 0; attempt <= _maxRetriesPerModel; attempt++) {
        try {
          final googleAI = FirebaseAI.googleAI();
          final generativeModel = googleAI.generativeModel(
            model: modelName,
            systemInstruction: Content.system(systemInstruction),
            generationConfig: GenerationConfig(
              temperature: _temperature,
              maxOutputTokens: _maxOutputTokens,
            ),
          );

          final response = await generativeModel.generateContent([
            Content.text(userPrompt),
          ]).timeout(
            const Duration(seconds: 25),
            onTimeout: () {
              throw TimeoutException('La solicitud al modelo $modelName excedió el tiempo límite.');
            },
          );

          final text = response.text?.trim();
          if (text == null || text.isEmpty) {
            throw AiTutorException('El modelo devolvió una respuesta vacía.');
          }

          resultText = text;
          modelSucceeded = true;
          break; // Exit retry loop
        } on TimeoutException catch (e) {
          lastError = e;

          debugPrint('[AiTutorService] Timeout with $modelName (attempt $attempt): $e');
          if (attempt < _maxRetriesPerModel) {
            await Future.delayed(Duration(milliseconds: _retryDelaysMs[attempt]));
          }
        } catch (e) {
          lastError = e;

          final errorString = e.toString().toLowerCase();
          debugPrint('[AiTutorService] Error with model $modelName (attempt $attempt): $e');

          // If it's a transient server error, wait and retry this model
          final isTransientServer = errorString.contains('500') ||
              errorString.contains('503') ||
              errorString.contains('internal') ||
              errorString.contains('server error') ||
              errorString.contains('high demand');

          if (isTransientServer && attempt < _maxRetriesPerModel) {
            await Future.delayed(Duration(milliseconds: _retryDelaysMs[attempt]));
            continue;
          }

          // If quota exhausted (429), model retired/unavailable (404), or non-retryable on this model:
          // break out of retry loop to immediately try the next model in candidate chain!
          break;
        }
      }

      if (modelSucceeded && resultText != null) {
        return resultText;
      }

      debugPrint('[AiTutorService] Switching from $modelName to next fallback model...');
    }

    // If all candidate models in the chain failed, analyze last error
    debugPrint('[AiTutorService] All models in chain failed. Last error: $lastError');
    final errStr = lastError.toString().toLowerCase();

    if (errStr.contains('quota') ||
        errStr.contains('limit') ||
        errStr.contains('429') ||
        errStr.contains('resource_exhausted')) {
      throw AiTutorException(
        'Se ha alcanzado el límite diario de consultas de IA gratuitas. Por favor, intenta más tarde o mañana.',
        isRetryable: true,
      );
    } else if (errStr.contains('network') ||
        errStr.contains('connection') ||
        errStr.contains('socket') ||
        errStr.contains('clientexception')) {
      throw AiTutorException(
        'Error de conexión. Por favor, verifica tu acceso a internet e intenta nuevamente.',
        isRetryable: true,
      );
    } else if (errStr.contains('blocked') || errStr.contains('safety')) {
      throw AiTutorException(
        'El contenido fue bloqueado por políticas de seguridad.',
        isRetryable: false,
      );
    } else if (errStr.contains('no firebase app') || errStr.contains('channel-error')) {
      throw AiTutorException(
        'El servicio de Firebase no está inicializado correctamente.',
        isRetryable: false,
      );
    } else {
      throw AiTutorException(
        'El servicio de IA no está disponible en este momento. Por favor, intenta nuevamente en unos minutos.',
        isRetryable: true,
      );
    }
  }

  /// Ask the question-specific tutor about a specific question & explanation.
  Future<String> askTutor({
    required String studentDoubt,
    required String formQuestion,
    required String correctAnswer,
    required String theoreticalExplanation,
    List<Map<String, String>>? conversationHistory,
  }) async {
    // Guard: Check cooldown
    if (_lastRequestTime != null) {
      final timeSinceLastRequest = DateTime.now().difference(_lastRequestTime!);
      if (timeSinceLastRequest.inMilliseconds < _cooldownMs) {
        throw AiTutorException('Por favor, espera unos segundos antes de hacer otra pregunta.');
      }
    }

    // Guard: Trim inputs
    final trimmedDoubt = studentDoubt.trim();
    final trimmedTheory = theoreticalExplanation.trim();
    final trimmedQuestion = formQuestion.trim();
    final trimmedAnswer = correctAnswer.trim();

    // Guard: Empty doubt
    if (trimmedDoubt.isEmpty) {
      throw AiTutorException('Por favor, escribe tu duda antes de enviar.');
    }

    // Guard: Doubt too long
    if (trimmedDoubt.length > _maxDoubtLength) {
      throw AiTutorException('Tu duda es muy larga. Por favor, acórtala a menos de $_maxDoubtLength caracteres.');
    }

    // Guard: Empty theory
    if (trimmedTheory.isEmpty) {
      throw AiTutorException('No hay explicación teórica disponible para esta pregunta.');
    }

    _lastRequestTime = DateTime.now();

    const systemInstruction = r'''Eres "Tutor DGAC", un instructor de vuelo y tutor pedagógico virtual especializado en la preparación para exámenes teóricos de la Dirección General de Aeronáutica Civil (DGAC) de Chile.

PERSONALIDAD Y ENFOQUE PEDAGÓGICO:
- Eres cercano, empático, motivador y claro: un instructor de vuelo profesional que acompaña a su alumno con paciencia y rigor técnico para que domine la materia y apruebe con éxito.
- Explica de forma visual, didáctica y al grano por qué la opción correcta es la acertada y por qué se descartan las alternativas incorrectas.

REGLAS DE RESPUESTA:
1. EXPLICACIÓN CLARA Y FUNDAMENTADA:
   - Entrega una explicación concisa, pedagógica y directa del fundamento técnico, aerodinámico o normativo tras la opción correcta.
   - Usa listas con viñetas cuando desgloses conceptos o pasos.
   - Cita la fuente oficial DGAC o manual aeronáutico al concluir (ej: "Fuente: [DAR/DAN/AIP/Manual oficial DGAC]").

2. VOCABULARIO TÉCNICO FORMAL:
   - Utiliza terminología aeronáutica formal y académica en español según la DGAC / OACI.
   - NUNCA utilices jerga callejera ni modismos informales (prohibido "pesada de hocico", "trompa" o similares).
   - Traduce correctamente: para "nose-heavy" emplea siempre "pesada de nariz" o "tendencia al picado"; para "tail-heavy" emplea "pesada de cola" o "tendencia al encabritado".

3. FORMATO MATEMÁTICO Y SÍMBOLOS:
   - Usa sintaxis de LaTeX estándar ($ ... $ inline y $$ ... $$ en bloque) para variables como $V_1$, $V_2$, $V_R$, $V_S$ o fórmulas físicas.
   - Cero códigos corruptos o barras invertidas extras antes del signo dólar.

4. CIERRE PEDAGÓGICO:
   - Finaliza con una repregunta amable y atenta para verificar la comprensión del estudiante:
     "¿Te quedó clara esta explicación sobre la pregunta, o te gustaría profundizar en algún punto específico de la materia?"

5. ÁMBITO:
   - Si la consulta es totalmente ajena a la aviación (fútbol, cocina, etc.), redirige cordialmente la atención hacia la pregunta en estudio.''';

    final buffer = StringBuffer();
    buffer.writeln('<pregunta>$trimmedQuestion</pregunta>\n');
    buffer.writeln('<respuesta_correcta>$trimmedAnswer</respuesta_correcta>\n');
    buffer.writeln('<teoria>$trimmedTheory</teoria>\n');

    if (conversationHistory != null && conversationHistory.isNotEmpty) {
      buffer.writeln('Historial de la consulta previa sobre esta pregunta:');
      for (final msg in conversationHistory) {
        final role = msg['role'] == 'user' ? 'Estudiante' : 'Tutor DGAC';
        buffer.writeln('$role: ${msg['text']}');
      }
      buffer.writeln('');
    }

    buffer.writeln('<duda_del_estudiante>$trimmedDoubt</duda_del_estudiante>\n');
    buffer.writeln(r'''Instrucción de respuesta:
- Actúa como Tutor DGAC con tono cercano, motivador, empático y pedagógico.
- Entrega una explicación concisa, directa y clara del fundamento técnico o norma tras la opción correcta.
- NUNCA uses jerga coloquial o modismos callejeros (prohibido "pesada de hocico", "de hocico", etc.). Emplea "pesada de nariz" / "tendencia al picado".
- Usa listas con viñetas si explicas pasos o conceptos.
- Para fórmulas o cálculos usa LaTeX estándar ($ ... $ inline y $$ ... $$ en bloque). Escribe velocidades y parámetros como $V_1$, $V_2$, $V_R$ sin barras invertidas de escape antes del dólar.
- Cita la fuente oficial DGAC o el material provisto sin URLs externas.
- Si la duda está totalmente fuera del ámbito aeronáutico, redirige cordialmente hacia la pregunta en estudio.
- Finaliza con la repregunta de verificación:
"¿Te quedó clara esta explicación sobre la pregunta, o te gustaría profundizar en algún punto específico de la materia?"''');

    return await _callWithMultiModelFallback(
      userPrompt: buffer.toString(),
      systemInstruction: systemInstruction,
    );
  }

  /// Validación superficial de conectividad (Smoke Test ping / echo).
  /// Comprueba que el servicio se inicializa y puede emitir un prompt sin evaluar calidad de texto.
  Future<bool> pingProbe() async {
    try {
      final res = await _callWithMultiModelFallback(
        userPrompt: 'PING',
        systemInstruction: 'Responde únicamente con la palabra PONG.',
      );
      return res.isNotEmpty;
    } catch (e) {
      debugPrint('[AiTutorService.pingProbe] Nota de conectividad: $e');
      return false;
    }
  }

  /// Ask the general tutor about any aeronautical subject.
  Future<String> askGeneralTutor({
    required String studentQuestion,
    List<Map<String, Object>>? subjectData,
    List<Map<String, String>>? conversationHistory,
  }) async {
    // Guard: Check cooldown
    if (_lastRequestTime != null) {
      final timeSinceLastRequest = DateTime.now().difference(_lastRequestTime!);
      if (timeSinceLastRequest.inMilliseconds < _cooldownMs) {
        throw AiTutorException('Por favor, espera unos segundos antes de hacer otra pregunta.');
      }
    }

    final trimmedQuestion = studentQuestion.trim();

    // Guard: Empty question
    if (trimmedQuestion.isEmpty) {
      throw AiTutorException('Por favor, escribe tu pregunta antes de enviar.');
    }

    // Guard: Question too long
    if (trimmedQuestion.length > _maxQuestionLength) {
      throw AiTutorException('Tu pregunta es muy larga. Por favor, acórtala a menos de $_maxQuestionLength caracteres.');
    }

    _lastRequestTime = DateTime.now();

    // Smart context filtering: retrieves only the most relevant questions & theory
    // instead of dumping the entire 300KB database into the prompt.
    final relevantContext = _extractRelevantTheory(
      query: trimmedQuestion,
      subjectData: subjectData,
    );

    const systemInstruction = r'''Eres "Tutor DGAC", un instructor de vuelo y tutor pedagógico virtual especializado en la preparación de alumnos para exámenes teóricos de la Dirección General de Aeronáutica Civil (DGAC) de Chile.

PERSONALIDAD Y TONO:
- Eres cercano, empático, motivador y claro: un instructor de vuelo apasionado por la enseñanza que acompaña al alumno para que domine la teoría y apruebe con honores.
- NUNCA respondas con frialdad ni como un mensaje de error del sistema. Si el alumno tiene dudas o dificultades, acompáñalo con paciencia y pedagogía.

REGLAS DE INTERACCIÓN Y ÁMBITO:

1. PREGUNTAS Y MATERIAS DEL EXAMEN:
   - Tu ámbito son las materias teóricas oficiales de la DGAC: Aerodinámica, Meteorología, Navegación, Reglamentación (DAR/DAN/AIP), Operaciones de Vuelo, Performance y Motores, y Peso & Balance.
   - CONSULTAS SOBRE NÚMEROS DE PREGUNTA O ENSAYOS (ej: "no entendí la pregunta 22 de meteorología", "la 15 de aerodinámica", "la pregunta 5 del ensayo"):
     * ¡ESTAS CONSULTAS SÍ SON DE LA MATERIA! Son dudas de estudio legítimas del alumno.
     * Revisa el "Contexto teórico y preguntas de referencia relacionadas" provisto abajo:
       - Si encuentras la pregunta correspondiente (ej. pregunta 22 de meteorología): identifícala con entusiasmo, cítala brevemente y explica con claridad didáctica por qué la alternativa correcta es la indicada y el fundamento técnico/normativo.
       - Si la pregunta específica no aparece en el contexto o falta información para identificarla: NO rechaces al alumno. Respóndele amablemente con entusiasmo:
         "¡Hola! Claro que sí, con mucho gusto revisamos esa pregunta de [Materia]. Como en cada ensayo las preguntas se ordenan aleatoriamente, ¿podrías indicarme qué dice el enunciado o de qué tema trata (por ejemplo: bruma, frentes, altímetro, sustentación, V1)? Apenas me des ese detalle, la resolvemos juntos paso a paso."

2. SALUDOS Y DIÁLOGO CORDIAL:
   - Si el estudiante saluda ("hola", "buenas tardes", "cómo estás"):
     Responde con calidez y disposición:
     "¡Hola! Qué gusto saludarte. Soy tu tutor para los exámenes teóricos de la DGAC. ¿Qué materia o duda aeronáutica te gustaría revisar hoy?"

3. FILTRO DE ÁMBITO (SOLO PARA TEMAS TOTALMENTE AJENOS A LA AVIACIÓN):
   - ÚNICAMENTE si el estudiante realiza una consulta que NO tiene relación alguna con la aviación (ejemplos: recetas de cocina, farándula, fútbol, política partidista, tareas escolares no aeronáuticas):
     Redirige amablemente la conversación con simpatía:
     "Mi especialidad es la teoría y normativa aeronáutica de la DGAC de Chile (Aerodinámica, Meteorología, Reglamentación, Operaciones, Motores, Peso & Balance). Cuéntame, ¿qué concepto aeronáutico o pregunta de examen te gustaría repasar?"

4. TERMINOLOGÍA TÉCNICA FORMAL (CERO MODISMOS COLOQUIALES):
   - Utiliza siempre terminología aeronáutica formal y académica en español según la reglamentación DGAC / OACI.
   - NUNCA utilices jerga callejera ni modismos informales (estrictamente prohibido "pesada de hocico", "irse de hocico", "trompa" o vulgaridades).
   - Traduce y utiliza la nomenclatura aeronáutica correcta: para "nose-heavy" emplea siempre "pesada de nariz" o "tendencia al picado / momento de cabeceo abajo"; para "tail-heavy" emplea "pesada de cola" o "tendencia al encabritado / momento de cabeceo arriba".

5. FORMATO MATEMÁTICO Y SÍMBOLOS:
   - Usa sintaxis de LaTeX estándar limpia: $ ... $ para expresiones inline (ej: $V_1$, $V_2$, $V_R$, $V_S$, $\rho$) y $$ ... $$ para fórmulas en bloque.
   - Sin códigos extraños, sin %%2$ ni barras invertidas extras antes del signo dólar.

6. FUENTES Y PEDAGOGÍA:
   - Basa tus explicaciones en la reglamentación oficial DGAC (DAR, DAN, AIP) y manuales de vuelo oficiales. Cita la norma correspondiente al concluir (ej: "Fuente: [DAR/DAN/Manual oficial DGAC]").
   - Usa listas con viñetas para desglosar conceptos complejos.
   - Concluye con una pregunta atenta y pedagógica que invite a confirmar la comprensión (ej: "¿Te quedó clara esta explicación o te gustaría profundizar en algún punto específico?").''';

    final buffer = StringBuffer();

    if (conversationHistory != null && conversationHistory.isNotEmpty) {
      buffer.writeln('Historial reciente de la conversación:');
      for (final msg in conversationHistory.take(4)) {
        final role = msg['role'] == 'user' ? 'Estudiante' : 'Tutor';
        buffer.writeln('$role: ${msg['text']}');
      }
      buffer.writeln('');
    }

    if (relevantContext.isNotEmpty) {
      buffer.writeln('Contexto teórico y preguntas de referencia relacionadas:');
      buffer.writeln(relevantContext);
      buffer.writeln('');
    }

    buffer.writeln('Pregunta del estudiante:');
    buffer.writeln(trimmedQuestion);

    return await _callWithMultiModelFallback(
      userPrompt: buffer.toString(),
      systemInstruction: systemInstruction,
    );
  }

  /// Extracts the top 3 most relevant questions/explanations based on keyword & question number matching
  /// to keep prompts compact, fast (<2s), and well within token quotas.
  String _extractRelevantTheory({
    required String query,
    required List<Map<String, Object>>? subjectData,
  }) {
    if (subjectData == null || subjectData.isEmpty) {
      return '';
    }

    final queryLower = query.toLowerCase();

    // 1. Extract any question numbers in the query (e.g., "22", "5", "10")
    final numberMatches = RegExp(r'\b\d+\b')
        .allMatches(queryLower)
        .map((m) => m.group(0)!)
        .toSet();

    // 2. Identify subject hints in the user's query
    final bool mentionsMeteo = queryLower.contains('meteo');
    final bool mentionsAero = queryLower.contains('aero');
    final bool mentionsRegla = queryLower.contains('regla');
    final bool mentionsMotor = queryLower.contains('motor') || queryLower.contains('perform');
    final bool mentionsOper = queryLower.contains('oper');
    final bool mentionsPeso = queryLower.contains('peso') || queryLower.contains('balance');

    // Common Spanish stop words to ignore during keyword matching
    const stopWords = {
      'el', 'la', 'los', 'las', 'un', 'una', 'unos', 'unas', 'de', 'del',
      'a', 'en', 'para', 'por', 'con', 'sin', 'sobre', 'que', 'como', 'cual',
      'cuales', 'cuando', 'donde', 'quien', 'es', 'son', 'fue', 'ser', 'estar',
      'hay', 'tiene', 'tienen', 'este', 'esta', 'estos', 'estas', 'se', 'lo',
      'al', 'su', 'sus', 'mi', 'me', 'y', 'o', 'pero', 'mas', 'si', 'no',
      'pregunta', 'examen', 'entendi', 'duda', 'explicame', 'dime'
    };

    final keywords = queryLower
        .replaceAll(RegExp(r'[^\w\sáéíóúüñ]'), ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.length >= 3 && !stopWords.contains(word))
        .toSet();

    final scoredItems = <({int score, String question, String explanation, String options})>[];

    for (final item in subjectData) {
      final question = item['texto']?.toString() ?? '';
      final explanation = item['explicacion']?.toString() ?? '';
      if (explanation.isEmpty && question.isEmpty) continue;

      final questionLower = question.toLowerCase();
      final explanationLower = explanation.toLowerCase();
      final combined = '$questionLower $explanationLower';

      int score = 0;

      // Question number matching: massive boost if the question matches the requested number (e.g. "22.-", "22.", "22 -")
      for (final num in numberMatches) {
        if (questionLower.startsWith('$num.-') ||
            questionLower.startsWith('$num.') ||
            questionLower.startsWith('$num -') ||
            questionLower.contains(' $num.-') ||
            questionLower.contains(' $num.')) {
          score += 40;
        } else if (RegExp('\\b$num\\b').hasMatch(questionLower)) {
          score += 15;
        }
      }

      // Subject affinity matching
      if (mentionsMeteo && (combined.contains('meteo') || combined.contains('atmósfera') || combined.contains('viento') || combined.contains('bruma') || combined.contains('nube') || combined.contains('presión'))) {
        score += 15;
      }
      if (mentionsAero && (combined.contains('aero') || combined.contains('sustenta') || combined.contains('perfil') || combined.contains('resistencia') || combined.contains('stall') || combined.contains('flap') || combined.contains('control'))) {
        score += 15;
      }
      if (mentionsRegla && (combined.contains('dan') || combined.contains('dar') || combined.contains('regla') || combined.contains('aip') || combined.contains('espacio aéreo'))) {
        score += 15;
      }
      if (mentionsMotor && (combined.contains('motor') || combined.contains('mezcla') || combined.contains('potencia') || combined.contains('hélice') || combined.contains('cilindro'))) {
        score += 15;
      }
      if (mentionsOper && (combined.contains('operac') || combined.contains('procedimiento') || combined.contains('emergencia') || combined.contains('vuelo'))) {
        score += 15;
      }
      if (mentionsPeso && (combined.contains('peso') || combined.contains('balance') || combined.contains('cg') || combined.contains('centro de gravedad') || combined.contains('momento'))) {
        score += 15;
      }

      // Standard keyword matches
      for (final kw in keywords) {
        if (combined.contains(kw)) {
          score += 2;
        }
      }

      if (score > 0) {
        // Extract options/answers if available
        String optionsStr = '';
        final rawRespuestas = item['respuestas'];
        if (rawRespuestas is List) {
          final opts = <String>[];
          for (final r in rawRespuestas) {
            if (r is Map) {
              final rText = r['texto']?.toString() ?? '';
              final rPuntos = r['puntos'] as num? ?? 0;
              if (rText.isNotEmpty) {
                opts.add(rPuntos > 0 ? '$rText (Opción correcta)' : rText);
              }
            }
          }
          if (opts.isNotEmpty) {
            optionsStr = opts.join(' | ');
          }
        }

        scoredItems.add((
          score: score,
          question: question,
          explanation: explanation,
          options: optionsStr,
        ));
      }
    }

    scoredItems.sort((a, b) => b.score.compareTo(a.score));

    // Limit to top 3 matches and at most ~2500 characters
    final buffer = StringBuffer();
    int totalLength = 0;

    for (final item in scoredItems.take(3)) {
      final snippet = StringBuffer();
      snippet.writeln('Pregunta: ${item.question}');
      if (item.options.isNotEmpty) {
        snippet.writeln('Alternativas: ${item.options}');
      }
      snippet.writeln('Explicación y fundamentación: ${item.explanation}');
      snippet.writeln('---');

      final text = snippet.toString();
      if (totalLength + text.length > 2500) break;
      buffer.write(text);
      totalLength += text.length;
    }

    return buffer.toString().trim();
  }
}
