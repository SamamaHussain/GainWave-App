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
    apiKey: 'AIzaSyAo8M6wUMKvsPzA4itb1AoxyiGIO69xGBM',
    appId: '1:548356655847:web:d8363814ff06ce4810b042',
    messagingSenderId: '548356655847',
    projectId: 'gain-wave',
    authDomain: 'gain-wave.firebaseapp.com',
    storageBucket: 'gain-wave.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC8XrUsqS1jEAz21CpSX8HXmHRblGqC0fI',
    appId: '1:548356655847:android:707d20f8ccdc384710b042',
    messagingSenderId: '548356655847',
    projectId: 'gain-wave',
    storageBucket: 'gain-wave.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB80TQ_0Ricqecs-yaxAXDtt19O_vcwQ-0',
    appId: '1:548356655847:ios:7a3a59b592989aaf10b042',
    messagingSenderId: '548356655847',
    projectId: 'gain-wave',
    storageBucket: 'gain-wave.firebasestorage.app',
    iosBundleId: 'com.example.gainWaveApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB80TQ_0Ricqecs-yaxAXDtt19O_vcwQ-0',
    appId: '1:548356655847:ios:7a3a59b592989aaf10b042',
    messagingSenderId: '548356655847',
    projectId: 'gain-wave',
    storageBucket: 'gain-wave.firebasestorage.app',
    iosBundleId: 'com.example.gainWaveApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAo8M6wUMKvsPzA4itb1AoxyiGIO69xGBM',
    appId: '1:548356655847:web:c859795d4375a6fc10b042',
    messagingSenderId: '548356655847',
    projectId: 'gain-wave',
    authDomain: 'gain-wave.firebaseapp.com',
    storageBucket: 'gain-wave.firebasestorage.app',
  );
}