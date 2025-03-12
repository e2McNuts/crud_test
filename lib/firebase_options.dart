// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAEL9qhYgodusa7nzeOMMPGkUOJIxZUANc',
    appId: '1:265567101421:web:11edc885236b41a19347e4',
    messagingSenderId: '265567101421',
    projectId: 'crudtest-1a6d1',
    authDomain: 'crudtest-1a6d1.firebaseapp.com',
    storageBucket: 'crudtest-1a6d1.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDuHdtUwSGlv_6spfIEa-IDjhbpiMS-iyI',
    appId: '1:265567101421:android:5b6b364b171a01769347e4',
    messagingSenderId: '265567101421',
    projectId: 'crudtest-1a6d1',
    storageBucket: 'crudtest-1a6d1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCDhYuBmE9dpMaEokUSMbHqj-5dD7AnH8w',
    appId: '1:265567101421:ios:87f8680d32e9b3bb9347e4',
    messagingSenderId: '265567101421',
    projectId: 'crudtest-1a6d1',
    storageBucket: 'crudtest-1a6d1.firebasestorage.app',
    iosBundleId: 'com.example.crudTest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCDhYuBmE9dpMaEokUSMbHqj-5dD7AnH8w',
    appId: '1:265567101421:ios:87f8680d32e9b3bb9347e4',
    messagingSenderId: '265567101421',
    projectId: 'crudtest-1a6d1',
    storageBucket: 'crudtest-1a6d1.firebasestorage.app',
    iosBundleId: 'com.example.crudTest',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAEL9qhYgodusa7nzeOMMPGkUOJIxZUANc',
    appId: '1:265567101421:web:3b43caa28d67092f9347e4',
    messagingSenderId: '265567101421',
    projectId: 'crudtest-1a6d1',
    authDomain: 'crudtest-1a6d1.firebaseapp.com',
    storageBucket: 'crudtest-1a6d1.firebasestorage.app',
  );
}
