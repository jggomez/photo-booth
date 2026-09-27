import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/ai_badge_result.dart';
import '../../domain/entities/event_config.dart';
import '../../firebase_options.dart';

typedef GeminiMultimodalGenerator
    = Future<({String? vibeTitle, Uint8List? imageBytes})> Function({
  required String prompt,
  required Uint8List photoBytes,
});

/// Remote data source that interacts exclusively with 
/// through Firebase AI () and direct Firebase Vertex AI REST endpoint.
class AiBadgeRemoteDataSource {
  final FirebaseAI? _firebaseAi;
  final GeminiMultimodalGenerator? _geminiMultimodalGenerator;
  final http.Client _httpClient;
  final String? _apiKey;
  final String? _projectId;

  static const List<String> caribbeanFallbackTitles = [
    '¡Qué Chido Cancún! 100%',
    'Bomba Yucateca de Código',
    'Vibra Maya Sagrada 99%',
    '¡A Toda Madre en el Caribe!',
    'Kukulcán del Hot Reload',
    'Cenote Sagrado & Flutter 99%',
    '¡Qué Padre la Riviera Maya!',
    'Marquesita & Widgets 100%',
    'Dash en Chichén Itzá 98%',
    'Rey del Caribe Mexicano',
    '¡Chulada de Widget en Cancún!',
    'Pura Buena Vibra Yucateca',
  ];

  AiBadgeRemoteDataSource({
    FirebaseAI? firebaseAi,
    GeminiMultimodalGenerator? geminiMultimodalGenerator,
    http.Client? httpClient,
    String? apiKey,
    String? projectId,
  })  : _firebaseAi = firebaseAi,
        _geminiMultimodalGenerator = geminiMultimodalGenerator,
        _httpClient = httpClient ?? http.Client(),
        _apiKey = apiKey,
        _projectId = projectId;

  /// Tests connectivity and validity of a Gemini API key using .
  Future<({bool success, String message})> testApiKey(String apiKey) async {
    final key = apiKey.trim();
    if (key.isEmpty) {
      return (success: false, message: 'La API Key está vacía.');
    }
    try {
      final projectId = _projectId ?? DefaultFirebaseOptions.web.projectId;
      final appId = DefaultFirebaseOptions.web.appId;
      final uri = Uri.parse(
        'https://firebasevertexai.googleapis.com/v1beta/projects/$projectId/models/gemini-3.1-flash-image:generateContent?key=$key',
      );
      final res = await _httpClient.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'X-Firebase-AppId': appId,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': 'Ping'}
              ]
            }
          ]
        }),
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        return (
          success: true,
          message: '¡Conexión exitosa con Firebase AI (gemini-3.1-flash-image)!'
        );
      } else {
        String detail = 'Código HTTP ${res.statusCode}';
        try {
          final data = jsonDecode(res.body) as Map<String, dynamic>;
          detail = data['error']?['message'] ?? detail;
        } catch (_) {}
        return (success: false, message: 'Validación fallida: $detail');
      }
    } catch (e) {
      return (success: false, message: 'Error de conexión con Firebase AI: $e');
    }
  }

  /// Returns a deterministic fallback title for [attendeeName].
  static String resolveFallbackTitle(String attendeeName,
      [List<String>? titles]) {
    final list = (titles != null && titles.isNotEmpty)
        ? titles
        : caribbeanFallbackTitles;
    final cleanName = attendeeName.trim();
    if (cleanName.isEmpty) {
      return list.first;
    }
    final index = cleanName.hashCode.abs() % list.length;
    return list[index];
  }

  /// Backward compatible helper returning Caribbean catalog title.
  static String getFallbackTitle(String attendeeName) =>
      resolveFallbackTitle(attendeeName);

  /// Invokes  to produce an illustrated portrait and short vibe title.
  Future<AiBadgeResult> generateBadge({
    required Uint8List photoBytes,
    required String attendeeName,
    String? promptTemplate,
    List<String>? fallbackTitles,
    String? customApiKey,
  }) async {
    final String promptText;
    if (promptTemplate != null && promptTemplate.trim().isNotEmpty) {
      promptText = promptTemplate.replaceAll('{name}', attendeeName);
    } else {
      promptText = EventConfig.defaultQuito()
          .promptTemplate
          .replaceAll('{name}', attendeeName)
          .replaceAll('{eventName}', 'DevFest Quito 2026')
          .replaceAll('{location}', 'Quito, Ecuador')
          .replaceAll('{hashtag}', '#devfestquito26');
    }

    String? aiVibeTitle;
    Uint8List? generatedImageBytes;

    try {
      final customGenerator = _geminiMultimodalGenerator;
      if (customGenerator != null) {
        final result = await customGenerator(
          prompt: promptText,
          photoBytes: photoBytes,
        ).timeout(const Duration(seconds: 20));

        aiVibeTitle = result.vibeTitle;
        generatedImageBytes = result.imageBytes;
      } else {
        bool sdkSucceeded = false;
        // Channel 1: Firebase AI SDK if no custom key overrides it
        if (customApiKey == null || customApiKey.trim().isEmpty) {
          try {
            final firebaseAi = _firebaseAi ?? FirebaseAI.googleAI();
            final model = firebaseAi.generativeModel(
              model: 'gemini-3.1-flash-image',
              generationConfig: GenerationConfig(
                responseModalities: [
                  ResponseModalities.text,
                  ResponseModalities.image,
                ],
              ),
            );

            final prompt = [
              Content.multi([
                TextPart(promptText),
                InlineDataPart('image/jpeg', photoBytes),
              ]),
            ];

            final response = await model
                .generateContent(prompt)
                .timeout(const Duration(seconds: 20));

            final parts = response.candidates.firstOrNull?.content.parts ?? [];
            for (final part in parts) {
              if (part is TextPart) {
                aiVibeTitle ??= part.text;
              }
              if (part is InlineDataPart) {
                generatedImageBytes ??= part.bytes;
              }
            }

            if (aiVibeTitle != null || generatedImageBytes != null) {
              sdkSucceeded = true;
            }
          } catch (_) {
            sdkSucceeded = false;
          }
        }

        // Channel 2: Direct REST call to Firebase Vertex AI endpoint
        if (!sdkSucceeded) {
          final directResult = await _generateViaFirebaseVertexAiApi(
            promptText: promptText,
            photoBytes: photoBytes,
            customApiKey: customApiKey,
          );
          aiVibeTitle = directResult.vibeTitle;
          generatedImageBytes = directResult.imageBytes;
        }
      }
    } catch (_) {
      // Gracefully catch timeout / offline issues
    }

    final isAiSuccess =
        (aiVibeTitle != null && aiVibeTitle.isNotEmpty) ||
        (generatedImageBytes != null && generatedImageBytes.isNotEmpty);

    final cleanVibe =
        _sanitizeVibeTitle(aiVibeTitle, attendeeName, fallbackTitles);
    final finalImageBytes =
        (generatedImageBytes != null && generatedImageBytes.isNotEmpty)
            ? generatedImageBytes
            : photoBytes;

    return AiBadgeResult(
      imageBytes: finalImageBytes,
      aiVibeTitle: cleanVibe,
      isAiTransformed: isAiSuccess,
    );
  }

  Future<({String? vibeTitle, Uint8List? imageBytes})>
      _generateViaFirebaseVertexAiApi({
    required String promptText,
    required Uint8List photoBytes,
    String? customApiKey,
  }) async {
    try {
      final key = (customApiKey != null && customApiKey.isNotEmpty)
          ? customApiKey
          : (_apiKey ?? DefaultFirebaseOptions.web.apiKey);
      final projectId = _projectId ?? DefaultFirebaseOptions.web.projectId;
      final appId = DefaultFirebaseOptions.web.appId;
      final uri = Uri.parse(
        'https://firebasevertexai.googleapis.com/v1beta/projects/$projectId/models/gemini-3.1-flash-image:generateContent?key=$key',
      );

      final payload = {
        'contents': [
          {
            'parts': [
              {'text': promptText},
              {
                'inlineData': {
                  'mimeType': 'image/jpeg',
                  'data': base64Encode(photoBytes),
                }
              }
            ]
          }
        ],
        'generationConfig': {
          'responseModalities': ['TEXT', 'IMAGE'],
        }
      };

      final res = await _httpClient
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'X-Firebase-AppId': appId,
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 25));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final candidates = data['candidates'] as List<dynamic>?;
        final firstCandidate = candidates?.firstOrNull as Map<String, dynamic>?;
        final content = firstCandidate?['content'] as Map<String, dynamic>?;
        final parts = content?['parts'] as List<dynamic>? ?? [];

        String? textResult;
        Uint8List? imageResult;

        for (final item in parts) {
          if (item is Map<String, dynamic>) {
            if (item.containsKey('text')) {
              textResult ??= item['text'] as String?;
            }
            if (item.containsKey('inlineData')) {
              final inline = item['inlineData'] as Map<String, dynamic>?;
              final b64 = inline?['data'] as String?;
              if (b64 != null && b64.isNotEmpty) {
                imageResult ??= base64Decode(b64);
              }
            }
          }
        }

        return (vibeTitle: textResult, imageBytes: imageResult);
      }
    } catch (_) {}

    return (vibeTitle: null, imageBytes: null);
  }

  String _sanitizeVibeTitle(
    String? rawTitle,
    String attendeeName, [
    List<String>? customFallbacks,
  ]) {
    if (rawTitle == null) {
      return resolveFallbackTitle(attendeeName, customFallbacks);
    }
    final trimmed = rawTitle
        .replaceAll(String.fromCharCode(13), ' ')
        .replaceAll(String.fromCharCode(10), ' ')
        .replaceAll('"', ' ')
        .trim();
    if (trimmed.isEmpty || trimmed.length < 3) {
      return resolveFallbackTitle(attendeeName, customFallbacks);
    }
    return trimmed;
  }
}
