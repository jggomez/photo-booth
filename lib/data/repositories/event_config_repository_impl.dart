import 'dart:typed_data';
import '../../domain/entities/event_config.dart';
import '../../domain/repositories/i_event_config_repository.dart';
import '../datasources/firebase_storage_datasource.dart';
import '../datasources/firestore_event_config_datasource.dart';
import '../models/event_config_model.dart';

/// Implementation of [IEventConfigRepository] connecting Firestore and Storage data sources.
class EventConfigRepositoryImpl implements IEventConfigRepository {
  final FirestoreEventConfigDataSource _firestoreDataSource;
  final FirebaseStorageDataSource _storageDataSource;

  EventConfigRepositoryImpl({
    FirestoreEventConfigDataSource? firestoreDataSource,
    FirebaseStorageDataSource? storageDataSource,
  })  : _firestoreDataSource =
            firestoreDataSource ?? FirestoreEventConfigDataSource(),
        _storageDataSource = storageDataSource ?? FirebaseStorageDataSource();

  @override
  Stream<EventConfig> watchEventConfig() {
    return _firestoreDataSource.streamConfig().map((model) => model.toDomain());
  }

  @override
  Future<EventConfig> getEventConfig() async {
    final model = await _firestoreDataSource.getConfig();
    return model.toDomain();
  }

  @override
  Future<void> saveEventConfig(EventConfig config) async {
    final model = EventConfigModel.fromDomain(config);
    await _firestoreDataSource.saveConfig(model);
  }

  @override
  Future<String> uploadEventAsset({
    required Uint8List bytes,
    required String fileName,
  }) async {
    return await _storageDataSource.uploadEventAsset(
      bytes: bytes,
      fileName: fileName,
    );
  }
}
