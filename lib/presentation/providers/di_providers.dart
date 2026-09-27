import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/camera_service_impl.dart';
import '../../data/datasources/firebase_storage_datasource.dart';
import '../../data/datasources/firestore_event_config_datasource.dart';
import '../../data/repositories/ai_badge_service_impl.dart';
import '../../data/repositories/event_config_repository_impl.dart';
import '../../data/repositories/user_card_repository_impl.dart';
import '../../domain/repositories/i_camera_service.dart';
import '../../domain/repositories/i_ai_badge_service.dart';
import '../../domain/repositories/i_event_config_repository.dart';
import '../../domain/repositories/i_user_card_repository.dart';
import '../../domain/usecases/clear_community_wall_usecase.dart';
import '../../domain/usecases/generate_ai_badge_usecase.dart';
import '../../domain/usecases/publish_user_card_usecase.dart';
import '../../domain/usecases/get_community_stream_usecase.dart';
import '../../domain/usecases/save_event_config_usecase.dart';
import '../../domain/usecases/test_gemini_api_key_usecase.dart';
import '../../domain/usecases/upload_event_asset_usecase.dart';
import '../../domain/usecases/watch_event_config_usecase.dart';

// --- Data Sources ---

final firebaseStorageDataSourceProvider =
    Provider<FirebaseStorageDataSource>((ref) {
  return FirebaseStorageDataSource();
});

final firestoreEventConfigDataSourceProvider =
    Provider<FirestoreEventConfigDataSource>((ref) {
  return FirestoreEventConfigDataSource();
});

// --- Repositories & Services ---

final cameraServiceProvider = Provider<ICameraService>((ref) {
  return CameraServiceImpl();
});

final aiBadgeServiceProvider = Provider<IAiBadgeService>((ref) {
  return AiBadgeServiceImpl();
});

final userCardRepositoryProvider = Provider<IUserCardRepository>((ref) {
  return UserCardRepositoryImpl();
});

final eventConfigRepositoryProvider = Provider<IEventConfigRepository>((ref) {
  return EventConfigRepositoryImpl(
    firestoreDataSource: ref.watch(firestoreEventConfigDataSourceProvider),
    storageDataSource: ref.watch(firebaseStorageDataSourceProvider),
  );
});

// --- Use Cases ---

final generateAiBadgeUseCaseProvider = Provider<GenerateAiBadgeUseCase>((ref) {
  return GenerateAiBadgeUseCase(ref.watch(aiBadgeServiceProvider));
});

final testGeminiApiKeyUseCaseProvider =
    Provider<TestGeminiApiKeyUseCase>((ref) {
  return TestGeminiApiKeyUseCase(ref.watch(aiBadgeServiceProvider));
});

final publishUserCardUseCaseProvider = Provider<PublishUserCardUseCase>((ref) {
  return PublishUserCardUseCase(ref.watch(userCardRepositoryProvider));
});

final getCommunityStreamUseCaseProvider =
    Provider<GetCommunityStreamUseCase>((ref) {
  return GetCommunityStreamUseCase(ref.watch(userCardRepositoryProvider));
});

final watchEventConfigUseCaseProvider =
    Provider<WatchEventConfigUseCase>((ref) {
  return WatchEventConfigUseCase(ref.watch(eventConfigRepositoryProvider));
});

final saveEventConfigUseCaseProvider = Provider<SaveEventConfigUseCase>((ref) {
  return SaveEventConfigUseCase(ref.watch(eventConfigRepositoryProvider));
});

final uploadEventAssetUseCaseProvider =
    Provider<UploadEventAssetUseCase>((ref) {
  return UploadEventAssetUseCase(ref.watch(eventConfigRepositoryProvider));
});

final clearCommunityWallUseCaseProvider =
    Provider<ClearCommunityWallUseCase>((ref) {
  return ClearCommunityWallUseCase(ref.watch(userCardRepositoryProvider));
});
