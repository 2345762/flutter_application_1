import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/widgets/general_ai_tutor_dialog.dart';
import 'package:flutter_application_1/services/ai_tutor_service.dart';

void main() {
  testWidgets('Predetermined questions hide when mobile keyboard appears and reappear when dismissed', (tester) async {
    Widget buildTestWidget({double keyboardHeight = 0}) {
      return MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: MediaQuery(
            data: MediaQueryData(
              viewInsets: EdgeInsets.only(bottom: keyboardHeight),
            ),
            child: GeneralAiTutorDialog(
              aiTutorService: AiTutorService(),
              userName: 'TestUser',
            ),
          ),
        ),
      );
    }

    // 1. Initial render with keyboard closed (keyboardHeight = 0)
    await tester.pumpWidget(buildTestWidget(keyboardHeight: 0));
    await tester.pumpAndSettle();

    // Verify predetermined questions are visible
    expect(find.byType(ActionChip), findsNWidgets(4));
    expect(find.text('¿Qué es la velocidad V1 y qué decisión se toma?'), findsOneWidget);
    expect(find.text('¿Cómo afecta la altitud de densidad al despegue?'), findsOneWidget);

    // 2. Simulate mobile keyboard opening (keyboardHeight = 300)
    await tester.pumpWidget(buildTestWidget(keyboardHeight: 300));
    await tester.pumpAndSettle();

    // Verify predetermined questions have disappeared
    expect(find.byType(ActionChip), findsNothing);
    expect(find.text('Escribe tu pregunta a continuación...'), findsOneWidget);

    // 3. Simulate mobile keyboard closing (keyboardHeight = 0)
    await tester.pumpWidget(buildTestWidget(keyboardHeight: 0));
    await tester.pumpAndSettle();

    // Verify predetermined questions reappear
    expect(find.byType(ActionChip), findsNWidgets(4));
    expect(find.text('¿Qué es la velocidad V1 y qué decisión se toma?'), findsOneWidget);
  });
}
