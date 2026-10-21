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
      try {
        await aiTutorService.askTutor(
          studentDoubt: 'Valid doubt about the question',
          formQuestion: 'Test question',
          correctAnswer: 'Test answer',
          theoreticalExplanation: 'Test theory explanation',
        );
        fail('Expected Firebase-related error in test environment, not success');
      } on AiTutorException catch (e) {
        expect(e.message, isNot(contains('Por favor, escribe tu duda')));
        expect(e.message, isNot(contains('Tu duda es muy larga')));
        expect(e.message, isNot(contains('No hay explicación teórica')));
      } catch (e) {
        expect(e, isNot(isA<AiTutorException>()));
      }
    });

    test('askGeneralTutor should throw when question is empty or whitespace', () async {
      expect(
        () => aiTutorService.askGeneralTutor(studentQuestion: '   '),
        throwsA(isA<AiTutorException>().having(
          (e) => e.message,
          'message',
          'Por favor, escribe tu pregunta antes de enviar.',
        )),
      );
    });

    test('askGeneralTutor should throw when question exceeds max length', () async {
      final longQuestion = 'q' * 1001;
      expect(
        () => aiTutorService.askGeneralTutor(studentQuestion: longQuestion),
        throwsA(isA<AiTutorException>().having(
          (e) => e.message,
          'message',
          contains('Tu pregunta es muy larga'),
        )),
      );
    });
  });
}
