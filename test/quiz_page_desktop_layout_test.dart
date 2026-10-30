import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';
import 'package:timezone/data/latest.dart' as tz_data;

void main() {
  setUpAll(() {
    tz_data.initializeTimeZones();
  });

  testWidgets('QuizPage renders AppBar, Question Card, Options, and Bottom Bar correctly on Desktop', (tester) async {
    // Desktop 1920 x 1080
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;

    final dummyPreguntas = [
      {
        'texto': '¿Cuál es la velocidad V1 en un avión comercial?',
        'respuestas': [
          {'texto': 'Velocidad de decisión en despegue', 'puntos': 1},
          {'texto': 'Velocidad de rotación', 'puntos': 0},
          {'texto': 'Velocidad de aterrizaje', 'puntos': 0},
          {'texto': 'Velocidad de ascenso óptimo', 'puntos': 0},
        ],
        'explicacion': 'La velocidad V1 es la velocidad máxima de decisión.',
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

    // 1. Verify AppBar is visible
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Estudio: AERODINÁMICA'), findsOneWidget);

    // 2. Verify Question Card is visible
    expect(find.textContaining('velocidad V1'), findsOneWidget);

    // 3. Verify Options are visible
    expect(find.text('Velocidad de decisión en despegue'), findsOneWidget);
    expect(find.text('Velocidad de rotación'), findsOneWidget);

    // 4. Verify Bottom Navigation Bar is visible and has reasonable compact height (not full screen!)
    expect(find.text('Anterior'), findsOneWidget);
    expect(find.text('Finalizar'), findsOneWidget);

    final bottomBarFinder = find.ancestor(
      of: find.text('Anterior'),
      matching: find.byType(Container),
    ).last;
    final bottomBarSize = tester.getSize(bottomBarFinder);
    
    // Bottom bar height must be around 60-90px, NEVER 1080px!
    expect(bottomBarSize.height, lessThan(120));
    expect(bottomBarSize.height, greaterThan(40));

    // Verify dark mode color matches app dark card / AppBar (0xFF1E293B)
    final bottomBarContainer = tester.widget<Container>(bottomBarFinder);
    final decoration = bottomBarContainer.decoration as BoxDecoration;
    expect(decoration.color, equals(const Color(0xFF1E293B)));

    // 5. Verify Question body has substantial height allocated
    final questionCardFinder = find.ancestor(
      of: find.textContaining('velocidad V1'),
      matching: find.byType(Card),
    ).first;
    expect(questionCardFinder, findsOneWidget);
    final questionCardSize = tester.getSize(questionCardFinder);
    expect(questionCardSize.width, lessThanOrEqualTo(800));

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
