import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/widgets/panel_estudio/subject_card.dart';
import 'package:flutter_application_1/widgets/panel_estudio/mode_selector_sheet.dart';
import 'package:flutter_application_1/models/life_data.dart';
import 'package:timezone/data/latest.dart' as tz_data;

void main() {
  setUpAll(() {
    tz_data.initializeTimeZones();
  });

  group('Desktop Responsiveness & Size Constraints', () {
    testWidgets('SubjectCard adapts scale for desktop (>=600) vs mobile (<600)', (tester) async {
      // 1. Mobile screen (390 x 844)
      tester.view.physicalSize = const Size(390 * 2, 844 * 2);
      tester.view.devicePixelRatio = 2.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 170,
                height: 140,
                child: SubjectCard(
                  nombre: 'AERODINÁMICA',
                  imagenAsset: 'assets/AERODINAMICA_SIN_FONDO.png',
                  streakDays: 3,
                  tieneIntentos: true,
                  ultimoPct: 0.8,
                  esMateriaActual: false,
                  progressPercentage: 0.5,
                  onTap: () {},
                  darkGradientColor: Colors.black,
                  darkTextColor: Colors.white,
                  lightTextColor: Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final mobileTransform = tester.widget<Transform>(
        find.byKey(const Key('subject_card_image_scale')),
      );
      // Mobile scale should be 0.88
      expect(mobileTransform.transform.storage[0], closeTo(0.88, 0.01));

      // 2. Desktop screen (1440 x 900)
      tester.view.physicalSize = const Size(1440 * 1, 900 * 1);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 250,
                height: 185,
                child: SubjectCard(
                  nombre: 'AERODINÁMICA',
                  imagenAsset: 'assets/AERODINAMICA_SIN_FONDO.png',
                  streakDays: 3,
                  tieneIntentos: true,
                  ultimoPct: 0.8,
                  esMateriaActual: false,
                  progressPercentage: 0.5,
                  onTap: () {},
                  darkGradientColor: Colors.black,
                  darkTextColor: Colors.white,
                  lightTextColor: Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final desktopTransform = tester.widget<Transform>(
        find.byKey(const Key('subject_card_image_scale')),
      );
      // Desktop scale should be 0.78 (compact, non-overwhelming)
      expect(desktopTransform.transform.storage[0], closeTo(0.78, 0.01));

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    testWidgets('ModeSelectorSheet is constrained to maxWidth 550 on wide screens', (tester) async {
      tester.view.physicalSize = const Size(1920 * 1, 1080 * 1);
      tester.view.devicePixelRatio = 1.0;

      final testLives = [
        LifeDisplayData(isAvailable: true),
        LifeDisplayData(isAvailable: true),
        LifeDisplayData(isAvailable: false, rechargeTime: DateTime.now().add(const Duration(hours: 2))),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ModeSelectorSheet(
              materiaNombre: 'METEOROLOGÍA',
              preguntasPractica: 25,
              preguntasTest: 25,
              lives: testLives,
              rachaActiva: 5,
              onPractice: () {},
              onTest: () {},
              onRacha: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final containerFinder = find.descendant(
        of: find.byType(ModeSelectorSheet),
        matching: find.byType(Container),
      ).first;

      final containerWidget = tester.widget<Container>(containerFinder);
      expect(containerWidget.constraints?.maxWidth, equals(550));

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
}
