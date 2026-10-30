import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/ai_tutor_service.dart';
import 'typewriter_text.dart';
import 'math_markdown_text.dart';
import '../main.dart' show StorageService;

class GeneralAiTutorDialog extends StatefulWidget {
  final AiTutorService aiTutorService;
  final List<Map<String, Object>>? subjectData;
  final String? userName;

  const GeneralAiTutorDialog({
    super.key,
    required this.aiTutorService,
    this.subjectData,
    this.userName,
  });

  static Future<void> show(
    BuildContext context, {
    AiTutorService? aiTutorService,
    List<Map<String, Object>>? subjectData,
    String? userName,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GeneralAiTutorDialog(
        aiTutorService: aiTutorService ?? AiTutorService(),
        subjectData: subjectData,
        userName: userName,
      ),
    );
  }

  @override
  State<GeneralAiTutorDialog> createState() => _GeneralAiTutorDialogState();
}

class _GeneralAiTutorDialogState extends State<GeneralAiTutorDialog> {
  static const List<String> _suggestionsPool = [
    // 1. Aerodinámica (7)
    '¿Qué es la velocidad V1 y qué decisión se toma?',
    '¿Cómo se produce la entrada en pérdida (stall) y cómo recuperarla?',
    '¿Qué es el factor de carga y cómo varía en virajes escarpados?',
    '¿Cuál es la diferencia entre resistencia parásita e inducida?',
    '¿Cómo influye el efecto suelo durante el despegue y aterrizaje?',
    '¿Qué es el ángulo de ataque crítico y cómo se relaciona con el perfil alar?',
    '¿Qué función cumplen los vórtices de punta de ala y los winglets?',

    // 2. Meteorología (7)
    '¿Qué condiciones favorecen la formación de engelamiento?',
    '¿Cómo se interpreta un reporte METAR y qué significa CAVOK?',
    '¿Qué peligros representan las microrráfagas y la cizalladura?',
    '¿Qué diferencia hay entre niebla de radiación y de advección?',
    '¿Cómo reconocer un frente frío frente a un frente cálido?',
    '¿Qué es la altitud de presión y cómo se calibra el altímetro en QNH y QNE?',
    '¿Cuáles son las etapas de desarrollo de una tormenta cumulonimbus?',

    // 3. Performance y Motores (7)
    '¿Cómo afecta la altitud de densidad al despegue?',
    '¿Qué es el motor crítico en aeronaves bimotores y por qué?',
    '¿Qué diferencia hay entre velocidad Vy y Vx?',
    '¿Qué causas provocan detonación o preignición en el motor?',
    '¿Cómo afecta el viento de cola a la carrera de despegue?',
    '¿Qué es la velocidad Vmc (mínima de control en el aire) en multimotores?',
    '¿Cómo influye la humedad y la temperatura en la potencia del motor?',

    // 4. Peso y Balance (6)
    '¿Qué es el centro de gravedad (CG) y qué pasa si está muy adelante?',
    '¿Qué peligros existen si el CG excede el límite posterior?',
    '¿Cómo se calcula el momento y la posición del Datum?',
    '¿Qué diferencia hay entre Peso Vacío Básico y Peso Máximo de Despegue?',
    '¿Qué es la Cuerda Media Aerodinámica (MAC) y cómo se calcula el %MAC?',
    '¿Cómo varía el centro de gravedad con el consumo de combustible en vuelo?',

    // 5. Operaciones de Vuelo (6)
    '¿Cuáles son los criterios para planificar un aeródromo de alternativa?',
    '¿Cuáles son los mínimos de combustible de reserva VFR e IFR?',
    '¿Qué procedimiento seguir ante una falla de comunicaciones en vuelo?',
    '¿Qué procedimiento se aplica ante una despresurización rápida en cabina?',
    '¿Qué significan los códigos transponder 7500, 7600 y 7700?',
    '¿Qué criterios definen una aproximación estabilizada antes de aterrizar?',

    // 6. Reglamentación DGAC Chile (7)
    '¿Cuáles son las limitaciones de velocidad bajo 10.000 pies según la DGAC?',
    '¿Qué requisitos exige la norma DAN 91 para volar en espacio aéreo C y D?',
    '¿Cuáles son los mínimos de visibilidad y techo para vuelo VFR en Chile?',
    '¿Cuáles son las reglas de altitud mínima de seguridad sobre zonas pobladas?',
    '¿Qué documentos obligatorios deben llevarse a bordo según la normativa chilena?',
    '¿Cuáles son los límites de tiempo de vuelo y descanso para tripulaciones?',
    '¿Qué vigencia tienen las licencias y habilitaciones aeronáuticas en Chile?',
  ];

  List<String> _suggestions = [];
  final TextEditingController _questionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isRetryable = true;
  int _remainingMessages = 3;
  String _effectiveUserName = '';

  @override
  void initState() {
    super.initState();
    _questionController.addListener(_onTextChanged);
    _initUserAndLimits();
    _randomizeSuggestions();
  }

  void _randomizeSuggestions() {
    final list = List<String>.from(_suggestionsPool)..shuffle();
    _suggestions = list.take(4).toList();
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initUserAndLimits() async {
    String user = widget.userName ?? '';
    if (user.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      user = prefs.getString('userName') ?? 'Usuario';
    }
    _effectiveUserName = user;

    final remaining = await StorageService.getRemainingDailyAiMessages(user);
    if (mounted) {
      setState(() {
        _remainingMessages = remaining;
      });
    }
  }

  @override
  void dispose() {
    _questionController.removeListener(_onTextChanged);
    _questionController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showDailyLimitNotice() {
    showDialog(
      context: context,
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.hourglass_top_rounded, color: Colors.orange, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Límite Diario Alcanzado',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: const Text(
            'Has utilizado tus 3 consultas diarias disponibles con el Tutor IA.\n\nPara optimizar los recursos y mantener un uso equitativo, tu saldo se reiniciará automáticamente a las 00:00 hrs.',
            style: TextStyle(fontSize: 13.5, height: 1.45),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendido', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitQuestion([String? presetQuestion]) async {
    if (!mounted) return;

    final question = (presetQuestion ?? _questionController.text).trim();
    if (question.isEmpty) return;

    // Check 3-messages daily limit
    if (_remainingMessages <= 0) {
      _showDailyLimitNotice();
      return;
    }

    final canSend = await StorageService.canSendAiMessage(_effectiveUserName);
    if (!canSend) {
      setState(() => _remainingMessages = 0);
      _showDailyLimitNotice();
      return;
    }

    // Snapshot history before adding this message
    final history = _messages.map((m) => {
      'role': m.isUser ? 'user' : 'model',
      'text': m.text,
    }).toList();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _isRetryable = true;
      _messages.add(ChatMessage(
        text: question,
        isUser: true,
      ));
      if (presetQuestion == null) {
        _questionController.clear();
      }
    });
    _scrollToBottom();

    try {
      final answer = await widget.aiTutorService.askGeneralTutor(
        studentQuestion: question,
        subjectData: widget.subjectData,
        conversationHistory: history,
      );

      if (!mounted) return;

      // Decrement daily limit upon successful response
      final updatedRemaining = await StorageService.incrementDailyAiMessages(_effectiveUserName);

      setState(() {
        _remainingMessages = updatedRemaining;
        _messages.add(ChatMessage(
          text: answer,
          isUser: false,
          isNew: true, // triggers typewriter animation
        ));
        _isLoading = false;
      });
      _scrollToBottom();
    } on AiTutorException catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.message;
        _isRetryable = e.isRetryable;
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Ocurrió un error inesperado al procesar tu consulta.';
        _isRetryable = true;
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _retry() {
    if (_messages.isNotEmpty && _messages.last.isUser) {
      final lastUserMessage = _messages.last.text;
      setState(() {
        _messages.removeLast();
        _errorMessage = null;
      });
      _submitQuestion(lastUserMessage);
    }
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 20;
    final isLimitReached = _remainingMessages <= 0;
    final isTextEmpty = _questionController.text.trim().isEmpty;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.85,
          maxWidth: 650,
        ),
        margin: EdgeInsets.only(
          bottom: keyboardHeight,
          left: 12,
          right: 12,
        ),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
            child: Row(
              children: [
                Icon(
                  Icons.psychology_outlined,
                  color: isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700,
                  size: 26,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tutor IA de Vuelo',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        'Resuelve dudas teóricas de todas las materias',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDarkMode ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                // Daily quota counter badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: isLimitReached
                        ? (isDarkMode ? Colors.red.withValues(alpha: 0.2) : Colors.red.shade50)
                        : (isDarkMode ? Colors.blue.withValues(alpha: 0.2) : Colors.blue.shade50),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isLimitReached
                          ? (isDarkMode ? Colors.red.shade400 : Colors.red.shade300)
                          : (isDarkMode ? Colors.blue.shade400 : Colors.blue.shade300),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isLimitReached ? Icons.block : Icons.bolt,
                        size: 13,
                        color: isLimitReached ? Colors.red : Colors.blue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$_remainingMessages/3 hoy',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isLimitReached
                              ? (isDarkMode ? Colors.red.shade300 : Colors.red.shade700)
                              : (isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_messages.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    tooltip: 'Limpiar conversación',
                    onPressed: _isLoading ? null : _clearChat,
                  ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Chat messages or suggestion empty state
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState(isDarkMode, isKeyboardVisible)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Align(
                          alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: _MessageBubble(
                            text: message.text,
                            isUser: message.isUser,
                            isNew: message.isNew,
                            isDarkMode: isDarkMode,
                            onComplete: () {
                              message.isNew = false;
                              _scrollToBottom();
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Error banner
          if (_errorMessage != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.red.withValues(alpha: 0.15) : Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDarkMode ? Colors.red.withValues(alpha: 0.4) : Colors.red.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: isDarkMode ? Colors.red.shade300 : Colors.red.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: isDarkMode ? Colors.red.shade200 : Colors.red.shade900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (_isRetryable)
                    TextButton(
                      onPressed: _retry,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        foregroundColor: isDarkMode ? Colors.red.shade300 : Colors.red.shade700,
                      ),
                      child: const Text('Reintentar', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),

          // Input field and send button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    focusNode: _focusNode,
                    maxLines: 4,
                    minLines: 1,
                    maxLength: 1000,
                    enabled: !_isLoading,
                    onChanged: (text) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: isLimitReached
                          ? 'Límite diario de 3 consultas alcanzado'
                          : 'Pregunta sobre aerodinámica, motores, peso y balance...',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? Colors.white38 : Colors.grey.shade500,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      counterText: '',
                    ),
                    onSubmitted: (_) {
                      if (!_isLoading && !isTextEmpty) {
                        _submitQuestion();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: (_isLoading || isTextEmpty)
                      ? null
                      : () => _submitQuestion(),
                  icon: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.send_rounded, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.blue.shade600 : Colors.blue.shade700,
                    disabledBackgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  }

  Widget _buildEmptyState(bool isDarkMode, bool isKeyboardVisible) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                child: child,
              ),
            );
          },
          child: isKeyboardVisible
              ? Column(
                  key: const ValueKey('empty_state_keyboard_active'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 28,
                      color: isDarkMode ? Colors.blue.shade300 : Colors.blue.shade600,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '¿En qué materia tienes dudas hoy?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Escribe tu pregunta a continuación...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: isDarkMode ? Colors.white38 : Colors.black45,
                      ),
                    ),
                  ],
                )
              : Column(
                  key: const ValueKey('empty_state_keyboard_hidden'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 40,
                      color: isDarkMode ? Colors.blue.shade300 : Colors.blue.shade600,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '¿En qué materia tienes dudas hoy?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'El tutor combina conceptos de Aerodinámica, Performance, Operaciones, Peso & Balance, Meteorología y Reglamentación.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white54 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Preguntas sugeridas:',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.blue.shade200 : Colors.blue.shade800,
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.shuffle_rounded, size: 16),
                          tooltip: 'Cambiar preguntas',
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            setState(() {
                              _randomizeSuggestions();
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: _suggestions.map((s) {
                        return ActionChip(
                          label: Text(
                            s,
                            style: const TextStyle(fontSize: 11),
                          ),
                          onPressed: _isLoading ? null : () => _submitQuestion(s),
                        );
                      }).toList(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isNew;
  final bool isDarkMode;
  final VoidCallback? onComplete;

  const _MessageBubble({
    required this.text,
    required this.isUser,
    this.isNew = false,
    required this.isDarkMode,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 520),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isUser
            ? (isDarkMode ? Colors.blue.shade600 : Colors.blue.shade700)
            : (isDarkMode ? const Color(0xFF2C2C2E) : Colors.grey.shade100),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isUser ? 16 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 16),
        ),
        border: isUser
            ? null
            : Border.all(
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
              ),
      ),
      child: isUser
          ? SelectableText(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                height: 1.45,
              ),
            )
          : (isNew
              ? TypewriterText(
                  text: text,
                  onComplete: onComplete,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 13.5,
                    height: 1.45,
                  ),
                )
              : MathMarkdownText(
                  text: text,
                  isDarkMode: isDarkMode,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 13.5,
                    height: 1.45,
                  ),
                )),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  bool isNew;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isNew = false,
  });
}
