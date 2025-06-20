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
    apiKey: 'AIzaSyCdJfQdbo6NBof__deH3muN0VI9jYVEQgE',
    appId: '1:158332835040:web:3a698b56f046281b8f6c85',
    messagingSenderId: '158332835040',
    projectId: 'cinema-app-6e991',
    authDomain: 'cinema-app-6e991.firebaseapp.com',
    storageBucket: 'cinema-app-6e991.firebasestorage.app',
    measurementId: 'G-EZBEXDZ1K1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDWIO5pvo7bqGzV-__TWO8_PVvyQKFNJoY',
    appId: '1:158332835040:android:12d7ea09d1bc26548f6c85',
    messagingSenderId: '158332835040',
    projectId: 'cinema-app-6e991',
    storageBucket: 'cinema-app-6e991.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBwTWJd9n-mABHjT3anM2whe6x_fLSPPkM',
    appId: '1:158332835040:ios:4905bcd0e99221258f6c85',
    messagingSenderId: '158332835040',
    projectId: 'cinema-app-6e991',
    storageBucket: 'cinema-app-6e991.firebasestorage.app',
    iosBundleId: 'com.example.cinemaApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBwTWJd9n-mABHjT3anM2whe6x_fLSPPkM',
    appId: '1:158332835040:ios:4905bcd0e99221258f6c85',
    messagingSenderId: '158332835040',
    projectId: 'cinema-app-6e991',
    storageBucket: 'cinema-app-6e991.firebasestorage.app',
    iosBundleId: 'com.example.cinemaApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCdJfQdbo6NBof__deH3muN0VI9jYVEQgE',
    appId: '1:158332835040:web:a0dc2d77998be0108f6c85',
    messagingSenderId: '158332835040',
    projectId: 'cinema-app-6e991',
    authDomain: 'cinema-app-6e991.firebaseapp.com',
    storageBucket: 'cinema-app-6e991.firebasestorage.app',
    measurementId: 'G-KF3BEQ6K75',
  );
}
