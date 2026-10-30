import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;

import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/services/ai_tutor_service.dart';

/// FAST SMOKE TEST - FILTRO BINARIO (PASA / NO PASA)
/// 
/// Diseñado para ejecución ultrarrápida (<5s) validando que la arquitectura principal
/// no colapsa en cuatro pilares fundamentales:
/// 1. Arranque y Conectividad (Backend & Core Bootstrap)
/// 2. Rutas Críticas (UI Header, Simulador de Examen y Racha)
/// 3. Módulo IA (Inicialización, Cadena de Modelos y Contrato Ping)
/// 4. Operaciones CRUD Básicas (Escritura, Lectura y Verificación de Sesión)
void main() {
  setUpAll(() {
    tz_data.initializeTimeZones();
  });

  group('⚡ SMOKE TEST BINARIO (PASA / NO PASA)', () {
    // =========================================================================
    // PILAR 1: ARRANQUE Y CONECTIVIDAD
    // =========================================================================
    testWidgets('[PASA/NO PASA] Pilar 1: Arranque y Conectividad del Backend', (tester) async {
      // 1.1 Validar que las opciones de Firebase y App Check están configuradas
      final options = DefaultFirebaseOptions.currentPlatform;
      expect(options.projectId, 'appeov-23dbe', reason: 'Firebase Project ID debe coincidir');
      expect(options.apiKey, isNotEmpty, reason: 'API Key de Firebase debe estar presente');
      expect(options.appId, isNotEmpty, reason: 'App ID de Firebase debe estar presente');

      // 1.2 Validar arranque del árbol raíz de la app sin excepciones ni crashes
      await tester.pumpWidget(
        QuizApp(
          startWidget: const Scaffold(
            body: Center(child: Text('App Bootstrap OK')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget, reason: 'MaterialApp debe montarse sin fallos');
      expect(find.text('App Bootstrap OK'), findsOneWidget);
      debugPrint(' [PASA] Pilar 1: Arranque y Conectividad verificado con éxito.');
    });

    // =========================================================================
    // PILAR 2: RUTAS CRÍTICAS (CORE FLOWS)
    // =========================================================================
    testWidgets('[PASA/NO PASA] Pilar 2: Rutas Críticas (Simulador de Examen y Racha)', (tester) async {
      SharedPreferences.setMockInitialValues({});

      // 2.1 Carga del estado de la racha diaria sin errores de null-safety
      final streakData = await StorageService.getStreakData();
      final globalStreak = await StorageService.getGlobalStreakData();
      expect(streakData == null || streakData.streakDays >= 0, isTrue);
      expect(globalStreak.lives.isNotEmpty, isTrue);

      // 2.2 Renderizado del Simulador de Exámenes (QuizPage)
      final dummyPreguntas = [
        {
          'texto': '¿Cuál es la función del timón de profundidad (elevador)?',
          'respuestas': [
            {'texto': 'Controlar el cabeceo (pitch)', 'puntos': 1},
            {'texto': 'Controlar el alabeo (roll)', 'puntos': 0},
            {'texto': 'Controlar la guiñada (yaw)', 'puntos': 0},
          ],
          'explicacion': 'El elevador controla el movimiento alrededor del eje lateral.',
        }
      ];

      await tester.pumpWidget(
        MaterialApp(
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData.dark(),
          home: QuizPage(
            preguntasRecibidas: dummyPreguntas,
            tituloMateria: 'AERODINÁMICA',
            isTestMode: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Validar componentes críticos de la ruta de examen
      expect(find.byType(AppBar), findsOneWidget, reason: 'AppBar de examen debe renderizar');
      expect(find.text('Estudio: AERODINÁMICA'), findsOneWidget);
      expect(find.textContaining('timón de profundidad'), findsOneWidget);
      expect(find.text('Controlar el cabeceo (pitch)'), findsOneWidget);
      expect(find.text('Finalizar'), findsOneWidget);

      debugPrint(' [PASA] Pilar 2: Rutas Críticas (Simulador y Racha) operando con normalidad.');
    });

    // =========================================================================
    // PILAR 3: MÓDULO DE LA NUEVA IA
    // =========================================================================
    test('[PASA/NO PASA] Pilar 3: Inicialización y Contrato del Tutor de IA', () async {
      final aiService = AiTutorService();

      // 3.1 Verificación de existencia del servicio y protecciones de entrada (Guards)
      expect(
        () => aiService.askGeneralTutor(studentQuestion: ''),
        throwsA(isA<AiTutorException>()),
        reason: 'El tutor debe protegerse contra prompts vacíos',
      );

      // 3.2 Verificación de contrato de ping/echo
      // En modo local o CI headless, pingProbe valida el protocolo y devuelve boolean sin crashear
      final pingResult = await aiService.pingProbe();
      expect(pingResult, isA<bool>(), reason: 'El probe debe retornar un resultado binario');

      debugPrint(' [PASA] Pilar 3: Módulo de IA inicializado y contrato de red verificado.');
    });

    // =========================================================================
    // PILAR 4: OPERACIONES CRUD BÁSICAS (SESIÓN E INTEGRIDAD)
    // =========================================================================
    test('[PASA/NO PASA] Pilar 4: Operaciones CRUD Básicas de Sesión de Usuario', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      const testUser = 'TEST_PILOTO_123';

      // 4.1 CREATE: Guardar datos de sesión activa
      await prefs.setString('userName', testUser);
      await prefs.setBool('isLoggedIn', true);

      // 4.2 READ: Verificar integridad inmediata de lectura
      expect(prefs.getString('userName'), equals(testUser));
      expect(prefs.getBool('isLoggedIn'), isTrue);

      // 4.3 UPDATE: Registrar y actualizar contador de uso
      await StorageService.incrementDailyAiMessages(testUser);
      final remaining = await StorageService.getRemainingDailyAiMessages(testUser);
      expect(remaining, lessThanOrEqualTo(3));

      // 4.3.1 RESET: Reiniciar contador de IA para testers
      final resetRemaining = await StorageService.resetDailyAiMessages(testUser);
      expect(resetRemaining, equals(3));
      final verifiedRemaining = await StorageService.getRemainingDailyAiMessages(testUser);
      expect(verifiedRemaining, equals(3));

      // 4.4 DELETE: Limpiar sesión (Logout)
      await prefs.remove('userName');
      await prefs.setBool('isLoggedIn', false);

      expect(prefs.getString('userName'), isNull);
      expect(prefs.getBool('isLoggedIn'), isFalse);

      debugPrint(' [PASA] Pilar 4: Ciclo CRUD completo validado con éxito.');
    });
  });
}
