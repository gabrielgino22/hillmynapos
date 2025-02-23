import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDbWKgE6WEOOPRlbM0QTBuR5RXfh_jJAyk',
    appId: '1:900581490367:web:f48fa3880238441ca2d00a',
    messagingSenderId: '900581490367',
    projectId: 'pos-app-2b674',
    authDomain: 'pos-app-2b674.firebaseapp.com',
    storageBucket: 'pos-app-2b674.firebasestorage.app',
    measurementId: 'G-9H25G2TDWK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDbWKgE6WEOOPRlbM0QTBuR5RXfh_jJAyk',
    appId: '1:900581490367:android:f48fa3880238441ca2d00a',
    messagingSenderId: '900581490367',
    projectId: 'pos-app-2b674',
    storageBucket: 'pos-app-2b674.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbWKgE6WEOOPRlbM0QTBuR5RXfh_jJAyk',
    appId: '1:900581490367:ios:f48fa3880238441ca2d00a',
    messagingSenderId: '900581490367',
    projectId: 'pos-app-2b674',
    storageBucket: 'pos-app-2b674.firebasestorage.app',
    iosBundleId: 'com.example.hillmynapos',
  );
}
