import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_card_model.dart';

/// Data source that encapsulates Cloud Firestore interactions for the `UserCards` collection.
class FirestoreUserCardsDataSource {
  final FirebaseFirestore _firestore;

  FirestoreUserCardsDataSource([FirebaseFirestore? firestore])
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('UserCards');

  /// Saves or overwrites a [UserCardModel] document in Firestore.
  Future<void> saveCard(UserCardModel model) async {
    await _collection.doc(model.id).set(model.toFirestore());
  }

  /// Streams real-time updates from `UserCards` collection, ordered by creation date descending.
  Stream<List<UserCardModel>> streamCards() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserCardModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Deletes all documents in `UserCards` collection in batches of up to 500.
  Future<void> deleteAllCards() async {
    final snapshot = await _collection.get();
    if (snapshot.docs.isEmpty) return;

    const batchSize = 500;
    for (int i = 0; i < snapshot.docs.length; i += batchSize) {
      final batch = _firestore.batch();
      final end = (i + batchSize < snapshot.docs.length)
          ? i + batchSize
          : snapshot.docs.length;
      for (int j = i; j < end; j++) {
        batch.delete(snapshot.docs[j].reference);
      }
      await batch.commit();
    }
  }
}
