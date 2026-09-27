import '../entities/event_config.dart';
import '../repositories/i_event_config_repository.dart';

/// Business use case to fetch the current event configuration snapshot directly.
class GetEventConfigUseCase {
  final IEventConfigRepository _repository;

  const GetEventConfigUseCase(this._repository);

  Future<EventConfig> execute() async {
    return await _repository.getEventConfig();
  }
}
