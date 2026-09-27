import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/event_config.dart';
import '../models/event_config_model.dart';

/// Data source encapsulating Cloud Firestore operations for the `AppConfig` collection.
class FirestoreEventConfigDataSource {
  final FirebaseFirestore _firestore;

  static const String collectionName = 'AppConfig';
  static const String currentDocId = 'event_current';

  FirestoreEventConfigDataSource([FirebaseFirestore? firestore])
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(collectionName);

  /// Streams real-time updates for `event_current`.
  /// If the document does not exist, yields [EventConfig.defaultQuito()].
  Stream<EventConfigModel> streamConfig() {
    return _collection.doc(currentDocId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return EventConfigModel.fromDomain(EventConfig.defaultQuito());
      }
      return EventConfigModel.fromFirestore(doc);
    });
  }

  /// Retrieves snapshot of `event_current`.
  /// If document does not exist, returns [EventConfig.defaultQuito()].
  Future<EventConfigModel> getConfig() async {
    final doc = await _collection.doc(currentDocId).get();
    if (!doc.exists || doc.data() == null) {
      return EventConfigModel.fromDomain(EventConfig.defaultQuito());
    }
    return EventConfigModel.fromFirestore(doc);
  }

  /// Saves or updates the event configuration document.
  Future<void> saveConfig(EventConfigModel model) async {
    await _collection.doc(currentDocId).set(
          model.toFirestore(),
          SetOptions(merge: true),
        );
  }
}
