import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cancun_dashbooth/domain/entities/event_config.dart';
import 'package:cancun_dashbooth/domain/repositories/i_event_config_repository.dart';
import 'package:cancun_dashbooth/domain/usecases/get_event_config_usecase.dart';

class MockEventConfigRepository extends Mock
    implements IEventConfigRepository {}

void main() {
  late MockEventConfigRepository mockRepository;
  late GetEventConfigUseCase useCase;

  setUp(() {
    mockRepository = MockEventConfigRepository();
    useCase = GetEventConfigUseCase(mockRepository);
  });

  test('delegates retrieval of event configuration to repository', () async {
    final expectedConfig = EventConfig.defaultQuito().copyWith(adminPin: '9999');
    when(() => mockRepository.getEventConfig())
        .thenAnswer((_) async => expectedConfig);

    final result = await useCase.execute();

    expect(result, equals(expectedConfig));
    expect(result.adminPin, equals('9999'));
    verify(() => mockRepository.getEventConfig()).called(1);
  });
}
