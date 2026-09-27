import 'package:cancun_dashbooth/domain/repositories/i_ai_badge_service.dart';
import 'package:cancun_dashbooth/domain/usecases/test_gemini_api_key_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAiBadgeService extends Mock implements IAiBadgeService {}

void main() {
  late MockAiBadgeService mockService;
  late TestGeminiApiKeyUseCase useCase;

  setUp(() {
    mockService = MockAiBadgeService();
    useCase = TestGeminiApiKeyUseCase(mockService);
  });

  test('delegates testApiKey call to IAiBadgeService and returns result', () async {
    when(() => mockService.testApiKey('test-key'))
        .thenAnswer((_) async => (success: true, message: 'OK'));

    final result = await useCase.execute('test-key');

    expect(result.success, isTrue);
    expect(result.message, equals('OK'));
    verify(() => mockService.testApiKey('test-key')).called(1);
  });
}
