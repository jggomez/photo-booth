import '../entities/event_config.dart';
import '../repositories/i_event_config_repository.dart';

/// Business use case to validate and persist event configuration changes.
class SaveEventConfigUseCase {
  final IEventConfigRepository _repository;

  const SaveEventConfigUseCase(this._repository);

  Future<void> execute(EventConfig config) async {
    final cleanName = config.eventName.trim();
    if (cleanName.length < 2) {
      throw ArgumentError(
          'El nombre del evento debe tener al menos 2 caracteres.');
    }

    final cleanPrompt = config.promptTemplate.trim();
    if (cleanPrompt.isEmpty) {
      throw ArgumentError('El prompt de IA no puede estar vacío.');
    }

    final cleanPin = config.adminPin.trim();
    if (cleanPin.length < 4) {
      throw ArgumentError(
          'El PIN de administrador debe tener al menos 4 caracteres.');
    }

    var cleanHashtag = config.hashtag.trim();
    if (cleanHashtag.isNotEmpty && !cleanHashtag.startsWith('#')) {
      cleanHashtag = '#$cleanHashtag';
    }

    final sanitizedConfig = config.copyWith(
      eventName: cleanName,
      hashtag: cleanHashtag,
      promptTemplate: cleanPrompt,
      adminPin: cleanPin,
      updatedAt: DateTime.now(),
    );

    await _repository.saveEventConfig(sanitizedConfig);
  }
}
