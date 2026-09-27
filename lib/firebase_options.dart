// File generated for EventBooth Web
// Project ID: event-booth-2026
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

/// Default [FirebaseOptions] for EventBooth Web.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are only configured for Flutter Web: '
      '${defaultTargetPlatform.name}',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD1zv9nFKdT-KXZRQNYCv4PEMvet8O0Z0Q',
    appId: '1:974051067:web:5eaa01b33db4f128a5c25e',
    messagingSenderId: '974051067',
    projectId: 'event-booth-2026',
    authDomain: 'event-booth-2026.firebaseapp.com',
    storageBucket: 'event-booth-2026.firebasestorage.app',
  );
}
