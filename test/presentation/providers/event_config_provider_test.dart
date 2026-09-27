import 'dart:typed_data';
import 'package:cancun_dashbooth/domain/entities/event_config.dart';
import 'package:cancun_dashbooth/domain/usecases/save_event_config_usecase.dart';
import 'package:cancun_dashbooth/domain/usecases/upload_event_asset_usecase.dart';
import 'package:cancun_dashbooth/presentation/providers/event_config_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSaveEventConfigUseCase extends Mock
    implements SaveEventConfigUseCase {}

class MockUploadEventAssetUseCase extends Mock
    implements UploadEventAssetUseCase {}

void main() {
  late MockSaveEventConfigUseCase mockSaveUseCase;
  late MockUploadEventAssetUseCase mockUploadUseCase;
  late EventConfigNotifier notifier;

  setUpAll(() {
    registerFallbackValue(EventConfig.defaultQuito());
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    mockSaveUseCase = MockSaveEventConfigUseCase();
    mockUploadUseCase = MockUploadEventAssetUseCase();
    notifier = EventConfigNotifier(
      saveUseCase: mockSaveUseCase,
      uploadUseCase: mockUploadUseCase,
      initialConfig: EventConfig.defaultQuito(),
    );
  });

  group('EventConfigNotifier Tests', () {
    test('initializes with default Quito preset', () {
      expect(notifier.state.config.eventName, equals('DevFest Quito 2026'));
      expect(notifier.state.config.eventBadgeLabel,
          equals('⚡ DevFest Quito 2026'));
    });

    test('applyCancunPreset updates state to Cancun preset', () {
      notifier.applyCancunPreset();
      expect(notifier.state.config.eventName, equals('FlutterConf LATAM 2026'));
      expect(notifier.state.config.eventBadgeLabel, equals('🌴 Cancún 2026'));
    });

    test('applyGenericPreset updates state to Generic preset', () {
      notifier.applyGenericPreset();
      expect(notifier.state.config.eventName, equals('Tech Event 2026'));
      expect(notifier.state.config.eventBadgeLabel, equals('🚀 Tech 2026'));
    });

    test('applyQuitoPreset updates state to Quito preset', () {
      notifier.applyCancunPreset();
      notifier.applyQuitoPreset();
      expect(notifier.state.config.eventName, equals('DevFest Quito 2026'));
    });

    test('saveConfig calls useCase and updates saveStatus', () async {
      when(() => mockSaveUseCase.execute(any())).thenAnswer((_) async {});

      final success = await notifier.saveConfig(
        notifier.state.config.copyWith(eventName: 'Custom Event'),
      );

      expect(success, isTrue);
      expect(notifier.state.saveStatus, isA<AsyncData>());
      expect(notifier.state.config.eventName, equals('Custom Event'));
      verify(() => mockSaveUseCase.execute(any())).called(1);
    });

    test('saveConfig sets AsyncError when useCase throws', () async {
      when(() => mockSaveUseCase.execute(any()))
          .thenThrow(ArgumentError('Invalid name'));

      final success = await notifier.saveConfig(
        notifier.state.config.copyWith(eventName: 'X'),
      );

      expect(success, isFalse);
      expect(notifier.state.saveStatus, isA<AsyncError>());
    });

    test('uploadAsset calls useCase and returns URL on success', () async {
      final bytes = Uint8List.fromList([1, 2, 3]);
      when(() => mockUploadUseCase.execute(
            bytes: any(named: 'bytes'),
            fileName: any(named: 'fileName'),
          )).thenAnswer((_) async => 'https://storage/event_assets/logo.png');

      final url = await notifier.uploadAsset(
        bytes: bytes,
        fileName: 'logo.png',
      );

      expect(url, equals('https://storage/event_assets/logo.png'));
      expect(notifier.state.uploadStatus.value,
          equals('https://storage/event_assets/logo.png'));
    });
  });
}
