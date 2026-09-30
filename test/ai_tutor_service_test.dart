import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/services/ai_tutor_service.dart';

void main() {
  group('AiTutorService - Guard Tests', () {
    late AiTutorService aiTutorService;

    setUp(() {
      aiTutorService = AiTutorService();
    });

    test('should throw AiTutorException when doubt is empty', () async {
      expect(
        () => aiTutorService.askTutor(
          studentDoubt: '',
          formQuestion: 'Test question',
          correctAnswer: 'Test answer',
          theoreticalExplanation: 'Test theory',
        ),
        throwsA(isA<AiTutorException>().having(
          (e) => e.message,
          'message',
          'Por favor, escribe tu duda antes de enviar.',
        )),
      );
    });

    test('should throw AiTutorException when doubt is only whitespace', () async {
      expect(
        () => aiTutorService.askTutor(
          studentDoubt: '   ',
          formQuestion: 'Test question',
          correctAnswer: 'Test answer',
          theoreticalExplanation: 'Test theory',
        ),
        throwsA(isA<AiTutorException>().having(
          (e) => e.message,
          'message',
          'Por favor, escribe tu duda antes de enviar.',
        )),
      );
    });

    test('should throw AiTutorException when doubt exceeds max length', () async {
      final longDoubt = 'a' * 501; // Exceeds 500 character limit
      
      expect(
        () => aiTutorService.askTutor(
          studentDoubt: longDoubt,
          formQuestion: 'Test question',
          correctAnswer: 'Test answer',
          theoreticalExplanation: 'Test theory',
        ),
        throwsA(isA<AiTutorException>().having(
          (e) => e.message,
          'message',
          contains('Tu duda es muy larga'),
        )),
      );
    });

    test('should throw AiTutorException when theory is empty', () async {
      expect(
        () => aiTutorService.askTutor(
          studentDoubt: 'Valid doubt',
          formQuestion: 'Test question',
          correctAnswer: 'Test answer',
          theoreticalExplanation: '',
        ),
        throwsA(isA<AiTutorException>().having(
          (e) => e.message,
          'message',
          'No hay explicación teórica disponible para esta pregunta.',
        )),
      );
    });

    test('should throw AiTutorException when theory is only whitespace', () async {
      expect(
        () => aiTutorService.askTutor(
          studentDoubt: 'Valid doubt',
          formQuestion: 'Test question',
          correctAnswer: 'Test answer',
          theoreticalExplanation: '   ',
        ),
        throwsA(isA<AiTutorException>().having(
          (e) => e.message,
          'message',
          'No hay explicación teórica disponible para esta pregunta.',
        )),
      );
    });

    test('should accept valid inputs without throwing guard exceptions', () async {
      // This test verifies that the guards don't reject valid inputs
      // Note: This will still throw because we don't have Firebase properly configured/mocked
      // but it should NOT throw a guard exception (empty doubt, too long, etc.)
      
      try {
        await aiTutorService.askTutor(
          studentDoubt: 'Valid doubt about the question',
          formQuestion: 'Test question',
          correctAnswer: 'Test answer',
          theoreticalExplanation: 'Test theory explanation',
        );
        // If we get here without Firebase setup, something is wrong
        fail('Expected Firebase-related error, not success');
      } on AiTutorException catch (e) {
        // Should not be a guard-related error
        expect(
          e.message,
          isNot(contains('Por favor, escribe tu duda')),
        );
        expect(
          e.message,
          isNot(contains('Tu duda es muy larga')),
        );
        expect(
          e.message,
          isNot(contains('No hay explicación teórica')),
        );
      } catch (e) {
        // Expected to fail due to Firebase not being configured in test environment
        // But should not fail due to guard conditions
        expect(e, isNot(isA<AiTutorException>()));
      }
    });
  });
}