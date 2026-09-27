import 'dart:typed_data';
import '../entities/event_config.dart';

/// Contract for watching, retrieving, and persisting dynamic event configuration.
abstract class IEventConfigRepository {
  /// Emits real-time updates of the active event configuration.
  Stream<EventConfig> watchEventConfig();

  /// Retrieves the current snapshot of the event configuration.
  Future<EventConfig> getEventConfig();

  /// Persists a new or updated [EventConfig].
  Future<void> saveEventConfig(EventConfig config);

  /// Uploads binary asset (logo, banner) and returns its public URL.
  Future<String> uploadEventAsset({
    required Uint8List bytes,
    required String fileName,
  });
}
