import 'package:cancun_dashbooth/domain/entities/event_config.dart';
import 'package:cancun_dashbooth/domain/repositories/i_event_config_repository.dart';
import 'package:cancun_dashbooth/domain/usecases/watch_event_config_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEventConfigRepository extends Mock
    implements IEventConfigRepository {}

void main() {
  late MockEventConfigRepository mockRepository;
  late WatchEventConfigUseCase useCase;

  setUp(() {
    mockRepository = MockEventConfigRepository();
    useCase = WatchEventConfigUseCase(mockRepository);
  });

  group('WatchEventConfigUseCase Tests', () {
    test('delegates stream to repository watchEventConfig', () {
      final config = EventConfig.defaultQuito();
      when(() => mockRepository.watchEventConfig())
          .thenAnswer((_) => Stream.value(config));

      final stream = useCase.execute();

      expect(stream, emits(config));
      verify(() => mockRepository.watchEventConfig()).called(1);
    });
  });
}
