import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

/// Data source for uploading badge images to Firebase Storage.
class FirebaseStorageDataSource {
  final FirebaseStorage _storage;

  FirebaseStorageDataSource([FirebaseStorage? storage])
      : _storage = storage ?? FirebaseStorage.instance;

  /// Uploads [imageBytes] as PNG to `user_cards/{cardId}.png`
  /// and returns the public download URL.
  Future<String> uploadBadgeImage({
    required Uint8List imageBytes,
    required String cardId,
  }) async {
    final ref = _storage.ref().child('user_cards/$cardId.png');
    final metadata = SettableMetadata(
      contentType: 'image/png',
      customMetadata: {
        'uploadedAt': DateTime.now().toIso8601String(),
        'app': 'EventBooth',
      },
    );

    final uploadTask = await ref.putData(imageBytes, metadata);
    return await uploadTask.ref.getDownloadURL();
  }

  /// Uploads [bytes] to `event_assets/{fileName}` and returns public download URL.
  Future<String> uploadEventAsset({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final ref = _storage.ref().child('event_assets/$fileName');
    final contentType =
        fileName.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg';
    final metadata = SettableMetadata(
      contentType: contentType,
      customMetadata: {
        'uploadedAt': DateTime.now().toIso8601String(),
        'app': 'EventBooth',
      },
    );

    final uploadTask = await ref.putData(bytes, metadata);
    return await uploadTask.ref.getDownloadURL();
  }
}
