import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/ai_badge_result.dart';
import '../../domain/usecases/generate_ai_badge_usecase.dart';
import 'di_providers.dart';

import '../../domain/entities/event_config.dart';
import 'event_config_provider.dart';

/// State of the AI Transformation stage.
class AiGenerationState {
  final AsyncValue<Uint8List?> imageBytes;
  final String statusMessage;
  final String? aiVibeTitle;
  final bool isAiTransformed;

  const AiGenerationState({
    required this.imageBytes,
    required this.statusMessage,
    this.aiVibeTitle,
    this.isAiTransformed = false,
  });

  AiGenerationState copyWith({
    AsyncValue<Uint8List?>? imageBytes,
    String? statusMessage,
    String? aiVibeTitle,
    bool? isAiTransformed,
    bool clearVibeTitle = false,
  }) {
    return AiGenerationState(
      imageBytes: imageBytes ?? this.imageBytes,
      statusMessage: statusMessage ?? this.statusMessage,
      aiVibeTitle: clearVibeTitle ? null : (aiVibeTitle ?? this.aiVibeTitle),
      isAiTransformed: isAiTransformed ?? this.isAiTransformed,
    );
  }
}

/// Notifier handling the AI Dash generation lifecycle with progress messages.
class AiGenerationNotifier extends StateNotifier<AiGenerationState> {
  final GenerateAiBadgeUseCase _useCase;
  final EventConfig? _eventConfig;
  Timer? _messageTimer;
  int _messageIndex = 0;

  static const List<String> _defaultMessages = [
    'Dash está preparando tu credencial para el evento...',
    'Generando tu retrato con inteligencia artificial...',
    'Afinando los últimos detalles de tu credencial...',
  ];

  AiGenerationNotifier(
    this._useCase, {
    EventConfig? eventConfig,
  })  : _eventConfig = eventConfig,
        super(const AiGenerationState(
          imageBytes: AsyncData(null),
          statusMessage: '',
          aiVibeTitle: null,
        ));

  Future<AiBadgeResult?> generateBadge({
    required Uint8List photoBytes,
    required String attendeeName,
    EventConfig? configOverride,
  }) async {
    final activeConfig =
        configOverride ?? _eventConfig ?? EventConfig.defaultQuito();
    final messages = activeConfig.loadingMessages.isNotEmpty
        ? activeConfig.loadingMessages
        : _defaultMessages;

    _startMessageTicker(messages);
    state = state.copyWith(
      imageBytes: const AsyncLoading(),
      statusMessage: messages[0],
    );

    try {
      final prompt = activeConfig.interpolatePrompt(attendeeName);
      final result = await _useCase.execute(
        photoBytes: photoBytes,
        attendeeName: attendeeName,
        promptTemplate: prompt,
        fallbackTitles: activeConfig.fallbackTitles,
        customApiKey: activeConfig.customApiKey,
      );
      _stopMessageTicker();
      state = state.copyWith(
        imageBytes: AsyncData(result.imageBytes),
        aiVibeTitle: result.aiVibeTitle,
        isAiTransformed: result.isAiTransformed,
        statusMessage: '¡Tu credencial está lista!',
      );
      return result;
    } catch (e, stack) {
      _stopMessageTicker();
      state = state.copyWith(
        imageBytes: AsyncError(e, stack),
        statusMessage: 'Ocurrió un error al procesar la imagen.',
      );
      return null;
    }
  }

  void reset() {
    _stopMessageTicker();
    state = const AiGenerationState(
      imageBytes: AsyncData(null),
      statusMessage: '',
      aiVibeTitle: null,
      isAiTransformed: false,
    );
  }

  void _startMessageTicker(List<String> messages) {
    _stopMessageTicker();
    _messageIndex = 0;
    _messageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (messages.isEmpty) return;
      _messageIndex = (_messageIndex + 1) % messages.length;
      state = state.copyWith(statusMessage: messages[_messageIndex]);
    });
  }

  void _stopMessageTicker() {
    _messageTimer?.cancel();
    _messageTimer = null;
  }

  @override
  void dispose() {
    _stopMessageTicker();
    super.dispose();
  }
}

final aiGenerationProvider =
    StateNotifierProvider<AiGenerationNotifier, AiGenerationState>((ref) {
  final useCase = ref.watch(generateAiBadgeUseCaseProvider);
  final eventConfig = ref.watch(currentEventConfigProvider);
  return AiGenerationNotifier(useCase, eventConfig: eventConfig);
});
