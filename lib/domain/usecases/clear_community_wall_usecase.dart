import '../repositories/i_user_card_repository.dart';

/// Use case to delete all published community cards from the album.
class ClearCommunityWallUseCase {
  final IUserCardRepository _repository;

  const ClearCommunityWallUseCase(this._repository);

  Future<void> call() => _repository.clearAllUserCards();
}
