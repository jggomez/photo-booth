import 'package:cancun_dashbooth/domain/entities/event_config.dart';
import 'package:cancun_dashbooth/domain/repositories/i_event_config_repository.dart';
import 'package:cancun_dashbooth/domain/usecases/save_event_config_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEventConfigRepository extends Mock
    implements IEventConfigRepository {}

void main() {
  late MockEventConfigRepository mockRepository;
  late SaveEventConfigUseCase useCase;

  setUpAll(() {
    registerFallbackValue(EventConfig.defaultQuito());
  });

  setUp(() {
    mockRepository = MockEventConfigRepository();
    useCase = SaveEventConfigUseCase(mockRepository);
  });

  group('SaveEventConfigUseCase Tests', () {
    test(
        'successfully sanitizes hashtag, trims fields, and calls save on repository',
        () async {
      when(() => mockRepository.saveEventConfig(any()))
          .thenAnswer((_) async {});

      final config = EventConfig.defaultQuito().copyWith(
        eventName: '  Quito Tech  ',
        hashtag: 'quito26',
        adminPin: '9999',
      );

      await useCase.execute(config);

      final captured =
          verify(() => mockRepository.saveEventConfig(captureAny())).captured;
      final savedConfig = captured.first as EventConfig;

      expect(savedConfig.eventName, equals('Quito Tech'));
      expect(savedConfig.hashtag, equals('#quito26'));
      expect(savedConfig.adminPin, equals('9999'));
      expect(savedConfig.updatedAt, isNotNull);
    });

    test('throws ArgumentError if eventName has fewer than 2 characters',
        () async {
      final config = EventConfig.defaultQuito().copyWith(eventName: ' ');
      expect(() => useCase.execute(config), throwsA(isA<ArgumentError>()));
      verifyZeroInteractions(mockRepository);
    });

    test('throws ArgumentError if promptTemplate is empty', () async {
      final config = EventConfig.defaultQuito().copyWith(promptTemplate: '  ');
      expect(() => useCase.execute(config), throwsA(isA<ArgumentError>()));
      verifyZeroInteractions(mockRepository);
    });

    test('throws ArgumentError if adminPin is less than 4 digits', () async {
      final config = EventConfig.defaultQuito().copyWith(adminPin: '12');
      expect(() => useCase.execute(config), throwsA(isA<ArgumentError>()));
      verifyZeroInteractions(mockRepository);
    });
  });
}
