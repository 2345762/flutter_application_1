import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/widgets/general_ai_tutor_dialog.dart';
import 'package:flutter_application_1/services/ai_tutor_service.dart';

void main() {
  setUpAll(() {
    tz_data.initializeTimeZones();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Predetermined questions hide when mobile keyboard appears and reappear when dismissed', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Widget buildTestWidget({double keyboardHeight = 0, String userName = 'alumno@gmail.com'}) {
      return MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                viewInsets: EdgeInsets.only(bottom: keyboardHeight),
              ),
              child: GeneralAiTutorDialog(
                aiTutorService: AiTutorService(),
                userName: userName,
              ),
            ),
          ),
        ),
      );
    }

    // 1. Initial render with keyboard closed for standard user (non-tester)
    await tester.pumpWidget(buildTestWidget(keyboardHeight: 0, userName: 'alumno@gmail.com'));
    await tester.pumpAndSettle();

    // Verify 4 predetermined questions are visible
    expect(find.byType(ActionChip), findsNWidgets(4));

    // Verify reload button is HIDDEN for non-testers
    expect(find.widgetWithText(OutlinedButton, 'Recargar otras preguntas'), findsNothing);

    // 2. Simulate mobile keyboard opening (keyboardHeight = 300)
    await tester.pumpWidget(buildTestWidget(keyboardHeight: 300, userName: 'alumno@gmail.com'));
    await tester.pumpAndSettle();

    // Verify predetermined questions have disappeared
    expect(find.byType(ActionChip), findsNothing);
    expect(find.text('Escribe tu pregunta a continuación...'), findsOneWidget);

    // 3. Simulate mobile keyboard closing (keyboardHeight = 0)
    await tester.pumpWidget(buildTestWidget(keyboardHeight: 0, userName: 'alumno@gmail.com'));
    await tester.pumpAndSettle();

    // Verify predetermined questions reappear
    expect(find.byType(ActionChip), findsNWidgets(4));

    // 4. Test tester users: reload button IS visible for all 3 testers
    for (final email in [
      'tomas.galarce@precadet.cl',
      'matyas.g.j@gmail.com',
      'benjamin.zambrano@precadet.cl',
    ]) {
      await tester.pumpWidget(buildTestWidget(keyboardHeight: 0, userName: email));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(OutlinedButton, 'Recargar otras preguntas'), findsOneWidget, reason: 'Failed for $email');
    }

    final initialQuestions = tester
        .widgetList<ActionChip>(find.byType(ActionChip))
        .map((chip) => (chip.label as Text).data!)
        .toSet();

    final reloadButton = find.widgetWithText(OutlinedButton, 'Recargar otras preguntas');
    await tester.tap(reloadButton);
    await tester.pumpAndSettle();

    final reloadedQuestions = tester
        .widgetList<ActionChip>(find.byType(ActionChip))
        .map((chip) => (chip.label as Text).data!)
        .toSet();

    expect(reloadedQuestions.length, 4);
    expect(reloadedQuestions.intersection(initialQuestions), isEmpty);

    // 5. Test resetting daily question limit for testers
    final prefs = await SharedPreferences.getInstance();
    final today = StorageService.getChileanTodayString();
    await prefs.setString('ai_daily_usage_matyas.g.j@gmail.com', json.encode({'date': today, 'count': 3}));

    await tester.pumpWidget(buildTestWidget(keyboardHeight: 0, userName: 'matyas.g.j@gmail.com'));
    await tester.pumpAndSettle();

    // Verify banner and reset button exist for tester when quota is 0
    final resetQuestionsBtn = find.widgetWithText(TextButton, 'Reiniciar preguntas');
    expect(resetQuestionsBtn, findsOneWidget);

    await tester.tap(resetQuestionsBtn);
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));

    // Verify quota is restored to 3/3
    expect(find.text('3/3 hoy'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Reiniciar preguntas'), findsNothing);
  });
}
