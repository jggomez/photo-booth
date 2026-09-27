import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cancun_dashbooth/domain/repositories/i_user_card_repository.dart';
import 'package:cancun_dashbooth/domain/usecases/clear_community_wall_usecase.dart';

class MockUserCardRepository extends Mock implements IUserCardRepository {}

void main() {
  late MockUserCardRepository mockRepository;
  late ClearCommunityWallUseCase useCase;

  setUp(() {
    mockRepository = MockUserCardRepository();
    useCase = ClearCommunityWallUseCase(mockRepository);
  });

  group('ClearCommunityWallUseCase Tests', () {
    test('delegates clearAllUserCards to repository', () async {
      when(() => mockRepository.clearAllUserCards()).thenAnswer((_) async {});

      await useCase.call();

      verify(() => mockRepository.clearAllUserCards()).called(1);
    });

    test('rethrows when repository throws exception', () async {
      when(() => mockRepository.clearAllUserCards())
          .thenThrow(Exception('Firestore batch error'));

      expect(() => useCase.call(), throwsA(isA<Exception>()));
      verify(() => mockRepository.clearAllUserCards()).called(1);
    });
  });
}
