import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/event_config.dart';
import '../../domain/usecases/save_event_config_usecase.dart';
import '../../domain/usecases/upload_event_asset_usecase.dart';
import 'di_providers.dart';

/// State of the admin/event configuration workflow.
class EventConfigState {
  final EventConfig config;
  final AsyncValue<void> saveStatus;
  final AsyncValue<String?> uploadStatus;

  const EventConfigState({
    required this.config,
    this.saveStatus = const AsyncData(null),
    this.uploadStatus = const AsyncData(null),
  });

  EventConfigState copyWith({
    EventConfig? config,
    AsyncValue<void>? saveStatus,
    AsyncValue<String?>? uploadStatus,
  }) {
    return EventConfigState(
      config: config ?? this.config,
      saveStatus: saveStatus ?? this.saveStatus,
      uploadStatus: uploadStatus ?? this.uploadStatus,
    );
  }
}

/// Notifier to manage event configuration edits, presets, and asset uploads.
class EventConfigNotifier extends StateNotifier<EventConfigState> {
  final SaveEventConfigUseCase _saveUseCase;
  final UploadEventAssetUseCase _uploadUseCase;

  EventConfigNotifier({
    required SaveEventConfigUseCase saveUseCase,
    required UploadEventAssetUseCase uploadUseCase,
    EventConfig? initialConfig,
  })  : _saveUseCase = saveUseCase,
        _uploadUseCase = uploadUseCase,
        super(EventConfigState(
          config: initialConfig ?? EventConfig.defaultQuito(),
        ));

  void updateConfig(EventConfig config) {
    state = state.copyWith(config: config);
  }

  void applyQuitoPreset() {
    state = state.copyWith(
      config: EventConfig.defaultQuito().copyWith(
        adminPin: state.config.adminPin,
      ),
    );
  }

  void applyCancunPreset() {
    state = state.copyWith(
      config: EventConfig.cancun().copyWith(
        adminPin: state.config.adminPin,
      ),
    );
  }

  void applyGenericPreset() {
    state = state.copyWith(
      config: EventConfig.generic().copyWith(
        adminPin: state.config.adminPin,
      ),
    );
  }

  Future<bool> saveConfig([EventConfig? configToSave]) async {
    final target = configToSave ?? state.config;
    state = state.copyWith(saveStatus: const AsyncLoading());
    try {
      await _saveUseCase.execute(target);
      state = state.copyWith(
        config: target,
        saveStatus: const AsyncData(null),
      );
      return true;
    } catch (e, stack) {
      state = state.copyWith(saveStatus: AsyncError(e, stack));
      return false;
    }
  }

  Future<String?> uploadAsset({
    required Uint8List bytes,
    required String fileName,
  }) async {
    state = state.copyWith(uploadStatus: const AsyncLoading());
    try {
      final url = await _uploadUseCase.execute(
        bytes: bytes,
        fileName: fileName,
      );
      state = state.copyWith(uploadStatus: AsyncData(url));
      return url;
    } catch (e, stack) {
      state = state.copyWith(uploadStatus: AsyncError(e, stack));
      return null;
    }
  }
}

/// Real-time stream of the active event configuration from Firestore.
final eventConfigStreamProvider = StreamProvider<EventConfig>((ref) {
  final useCase = ref.watch(watchEventConfigUseCaseProvider);
  return useCase.execute();
});

/// Current resolved EventConfig fallbacking to Quito preset.
final currentEventConfigProvider = Provider<EventConfig>((ref) {
  final asyncConfig = ref.watch(eventConfigStreamProvider);
  return asyncConfig.valueOrNull ?? EventConfig.defaultQuito();
});

/// Notifier provider for mutating event configuration in Admin screen.
final eventConfigNotifierProvider =
    StateNotifierProvider<EventConfigNotifier, EventConfigState>((ref) {
  final saveUseCase = ref.watch(saveEventConfigUseCaseProvider);
  final uploadUseCase = ref.watch(uploadEventAssetUseCaseProvider);
  final current = ref.watch(currentEventConfigProvider);

  return EventConfigNotifier(
    saveUseCase: saveUseCase,
    uploadUseCase: uploadUseCase,
    initialConfig: current,
  );
});
