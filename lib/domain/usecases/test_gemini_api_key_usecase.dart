import '../repositories/i_ai_badge_service.dart';

/// Use case that verifies connectivity and validity of a Gemini API key.
class TestGeminiApiKeyUseCase {
  final IAiBadgeService _service;

  TestGeminiApiKeyUseCase(this._service);

  Future<({bool success, String message})> execute(String apiKey) async {
    return await _service.testApiKey(apiKey);
  }
}
