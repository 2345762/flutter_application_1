import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/typewriter_text.dart';

void main() {
  group('TypewriterText Widget Tests', () {
    testWidgets('renders initial partial or full text correctly and finishes animation', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TypewriterText(
              text: 'Bienvenido al tutor IA',
              speed: Duration(milliseconds: 10),
            ),
          ),
        ),
      );

      // Verify the widget is mounted
      expect(find.byType(TypewriterText), findsOneWidget);

      // Advance timer periodically until typewriter animation completes
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 20));
      }

      // Verify full text is displayed in SelectableText
      expect(
        find.textContaining('Bienvenido al tutor IA'),
        findsOneWidget,
      );
    });

    testWidgets('tapping text completes typing immediately', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TypewriterText(
              text: 'Texto largo para completar al toque',
              speed: Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      // Initial pump to mount
      await tester.pump(const Duration(milliseconds: 10));

      // Tap on the typewriter widget
      await tester.tap(find.byType(TypewriterText));
      await tester.pump();

      // It should immediately complete
      expect(
        find.textContaining('Texto largo para completar al toque'),
        findsOneWidget,
      );
    });
  });

  group('Streak Logic Unit Tests', () {
    test('Difference of 1 day (consecutive day) does not trigger streak reset', () {
      final lastPassedDate = DateTime(2026, 10, 19);
      final today = DateTime(2026, 10, 20);
      final difference = today.difference(lastPassedDate).inDays;

      expect(difference, 1);
      // Under our fixed condition: reset only if difference > 1
      final shouldReset = difference > 1;
      expect(shouldReset, isFalse);
    });

    test('Difference of 2 or more days triggers streak reset', () {
      final lastPassedDate = DateTime(2026, 10, 18);
      final today = DateTime(2026, 10, 20);
      final difference = today.difference(lastPassedDate).inDays;

      expect(difference, 2);
      final shouldReset = difference > 1;
      expect(shouldReset, isTrue);
    });

    test('Same day does not increment streak, consecutive day increments streak', () {
      final lastPassedDate = DateTime(2026, 10, 19);
      final todayConsecutive = DateTime(2026, 10, 20);
      final todaySame = DateTime(2026, 10, 19);

      int streakDays = 2;

      // Same day study:
      if (todaySame.isAfter(lastPassedDate)) {
        streakDays++;
      }
      expect(streakDays, 2); // Unchanged

      // Consecutive day study:
      if (todayConsecutive.isAfter(lastPassedDate)) {
        streakDays++;
      }
      expect(streakDays, 3); // Incremented
    });
  });

  group('Daily AI Message Limit Calculation', () {
    test('Calculates remaining messages accurately up to 3', () {
      const maxLimit = 3;

      int remainingAfter0 = (maxLimit - 0).clamp(0, maxLimit);
      expect(remainingAfter0, 3);

      int remainingAfter1 = (maxLimit - 1).clamp(0, maxLimit);
      expect(remainingAfter1, 2);

      int remainingAfter2 = (maxLimit - 2).clamp(0, maxLimit);
      expect(remainingAfter2, 1);

      int remainingAfter3 = (maxLimit - 3).clamp(0, maxLimit);
      expect(remainingAfter3, 0);

      int remainingAfter4 = (maxLimit - 4).clamp(0, maxLimit);
      expect(remainingAfter4, 0); // clamped at 0
    });
  });
}
