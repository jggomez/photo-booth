import 'dart:typed_data';
import 'package:cancun_dashbooth/domain/repositories/i_event_config_repository.dart';
import 'package:cancun_dashbooth/domain/usecases/upload_event_asset_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEventConfigRepository extends Mock
    implements IEventConfigRepository {}

void main() {
  late MockEventConfigRepository mockRepository;
  late UploadEventAssetUseCase useCase;

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    mockRepository = MockEventConfigRepository();
    useCase = UploadEventAssetUseCase(mockRepository);
  });

  group('UploadEventAssetUseCase Tests', () {
    final validBytes = Uint8List.fromList([1, 2, 3, 4]);

    test('successfully uploads asset and returns public url', () async {
      when(() => mockRepository.uploadEventAsset(
                bytes: any(named: 'bytes'),
                fileName: any(named: 'fileName'),
              ))
          .thenAnswer(
              (_) async => 'https://storage.googleapis.com/assets/logo.png');

      final url = await useCase.execute(
        bytes: validBytes,
        fileName: 'logo.png',
      );

      expect(url, equals('https://storage.googleapis.com/assets/logo.png'));
      verify(() => mockRepository.uploadEventAsset(
            bytes: validBytes,
            fileName: 'logo.png',
          )).called(1);
    });

    test('throws ArgumentError if bytes are empty', () async {
      expect(
        () => useCase.execute(bytes: Uint8List(0), fileName: 'logo.png'),
        throwsA(isA<ArgumentError>()),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('throws ArgumentError if fileName is empty', () async {
      expect(
        () => useCase.execute(bytes: validBytes, fileName: '   '),
        throwsA(isA<ArgumentError>()),
      );
      verifyZeroInteractions(mockRepository);
    });

    test(
        'throws ArgumentError if fileName does not have a supported image extension',
        () async {
      expect(
        () => useCase.execute(bytes: validBytes, fileName: 'malicious.exe'),
        throwsA(isA<ArgumentError>()),
      );
      verifyZeroInteractions(mockRepository);
    });
  });
}
