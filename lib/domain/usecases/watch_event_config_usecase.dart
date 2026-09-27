import '../entities/event_config.dart';
import '../repositories/i_event_config_repository.dart';

/// Business use case to watch real-time updates of the active event configuration.
class WatchEventConfigUseCase {
  final IEventConfigRepository _repository;

  const WatchEventConfigUseCase(this._repository);

  Stream<EventConfig> execute() {
    return _repository.watchEventConfig();
  }
}
