import 'dart:typed_data';
import '../entities/ai_badge_result.dart';

/// Abstract contract for AI image transformation and testing using Google AI / Firebase AI.
abstract class IAiBadgeService {
  /// Transforms the given [photoBytes] incorporating event theme
  /// and mascot using multimodal AI models.
  Future<AiBadgeResult> generateDashBadge({
    required Uint8List photoBytes,
    required String attendeeName,
    String? promptTemplate,
    List<String>? fallbackTitles,
    String? customApiKey,
  });

  /// Tests connectivity and validity of a Gemini API key.
  Future<({bool success, String message})> testApiKey(String apiKey);
}
