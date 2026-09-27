import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cancun_dashbooth/data/datasources/firebase_storage_datasource.dart';
import 'package:cancun_dashbooth/data/datasources/firestore_event_config_datasource.dart';
import 'package:cancun_dashbooth/data/models/event_config_model.dart';
import 'package:cancun_dashbooth/data/repositories/event_config_repository_impl.dart';
import 'package:cancun_dashbooth/domain/entities/event_config.dart';

class MockStorageDataSource extends Mock implements FirebaseStorageDataSource {}

class MockFirestoreEventConfigDataSource extends Mock
    implements FirestoreEventConfigDataSource {}

void main() {
  late MockStorageDataSource mockStorage;
  late MockFirestoreEventConfigDataSource mockFirestore;
  late EventConfigRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
        EventConfigModel.fromDomain(EventConfig.defaultQuito()));
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    mockStorage = MockStorageDataSource();
    mockFirestore = MockFirestoreEventConfigDataSource();
    repository = EventConfigRepositoryImpl(
      firestoreDataSource: mockFirestore,
      storageDataSource: mockStorage,
    );
  });

  group('EventConfigRepositoryImpl Tests', () {
    test('watchEventConfig maps models stream to domain entities', () async {
      final model = EventConfigModel.fromDomain(EventConfig.defaultQuito());
      when(() => mockFirestore.streamConfig())
          .thenAnswer((_) => Stream.value(model));

      final stream = repository.watchEventConfig();
      final config = await stream.first;

      expect(config.eventName, equals('DevFest Quito 2026'));
      expect(config.eventBadgeLabel, equals('⚡ DevFest Quito 2026'));
      verify(() => mockFirestore.streamConfig()).called(1);
    });

    test('getEventConfig retrieves model and converts to domain entity',
        () async {
      final model = EventConfigModel.fromDomain(EventConfig.cancun());
      when(() => mockFirestore.getConfig()).thenAnswer((_) async => model);

      final config = await repository.getEventConfig();

      expect(config.eventName, equals('FlutterConf LATAM 2026'));
      verify(() => mockFirestore.getConfig()).called(1);
    });

    test('saveEventConfig converts domain entity to model and saves', () async {
      final domain = EventConfig.defaultQuito();
      when(() => mockFirestore.saveConfig(any()))
          .thenAnswer((_) async => Future.value());

      await repository.saveEventConfig(domain);

      verify(() => mockFirestore.saveConfig(any(that: isA<EventConfigModel>())))
          .called(1);
    });

    test('uploadEventAsset delegates to storage data source', () async {
      final bytes = Uint8List.fromList([1, 2, 3]);
      when(() => mockStorage.uploadEventAsset(
            bytes: any(named: 'bytes'),
            fileName: any(named: 'fileName'),
          )).thenAnswer((_) async => 'https://storage/event_assets/logo.png');

      final url = await repository.uploadEventAsset(
        bytes: bytes,
        fileName: 'logo.png',
      );

      expect(url, equals('https://storage/event_assets/logo.png'));
      verify(() => mockStorage.uploadEventAsset(
            bytes: bytes,
            fileName: 'logo.png',
          )).called(1);
    });
  });
}
