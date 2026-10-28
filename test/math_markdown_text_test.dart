import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_application_1/widgets/math_markdown_text.dart';

void main() {
  group('MathMarkdownText Widget Tests', () {
    testWidgets('renders plain text and bold text', (tester) async {
      const sample = 'Este es un texto con **énfasis en negrita** para el alumno.';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MathMarkdownText(text: sample),
          ),
        ),
      );

      expect(find.byType(MathMarkdownText), findsOneWidget);
      expect(find.textContaining('Este es un texto con '), findsOneWidget);
    });

    testWidgets(r'renders inline math with $...$', (tester) async {
      const sample = r'La fórmula de sustentación relaciona $L = \frac{1}{2}\rho V^2 S C_L$ con la velocidad.';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MathMarkdownText(text: sample),
          ),
        ),
      );

      // Verify that Math.tex was created for the inline formula
      expect(find.byType(Math), findsOneWidget);
    });

    testWidgets('renders display math blocks with \$\$...\$\$', (tester) async {
      const sample = '''
Para calcular el factor de carga en un viraje nivelado:
\$\$
n = \\frac{1}{\\cos(\\phi)}
\$\$
Donde \$\\phi\$ representa el ángulo de banqueo.
''';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MathMarkdownText(text: sample),
          ),
        ),
      );

      // We should have 2 Math widgets: one display ($$n = ...$$) and one inline ($\phi$)
      expect(find.byType(Math), findsNWidgets(2));
    });

    testWidgets('renders bracket display math \\[...\\]', (tester) async {
      const sample = '''
Cálculo de velocidad de pérdida:
\\[
V_s = \\sqrt{\\frac{2W}{\\rho S C_{L_{max}}}}
\\]
''';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MathMarkdownText(text: sample),
          ),
        ),
      );

      expect(find.byType(Math), findsOneWidget);
    });

    testWidgets('renders source badge with book icon for Fuente: line', (tester) async {
      const sample = '''
El motor crítico es aquel cuya falla resulta en el efecto más adverso en el control.

Fuente: FAA, Airplane Flying Handbook, FAA-H-8083-3C, cap. 13.
''';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MathMarkdownText(text: sample),
          ),
        ),
      );

      expect(find.byIcon(Icons.menu_book_rounded), findsOneWidget);
      expect(find.textContaining('FAA, Airplane Flying Handbook'), findsOneWidget);
    });

    testWidgets('gracefully handles invalid LaTeX with onErrorFallback', (tester) async {
      const sample = r'Ecuación con error sintáctico: $\frac{incompleto$ pero la app no debe fallar.';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MathMarkdownText(text: sample),
          ),
        ),
      );

      // The widget should render without throwing unhandled exceptions
      expect(find.byType(MathMarkdownText), findsOneWidget);
    });
  });
}
