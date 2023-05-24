// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDB9IZYnhwjsUIaBL_TrrKI3CcxVwDXc0g',
    appId: '1:613778494881:web:9d2bc3f7f54d60ae6f27e0',
    messagingSenderId: '613778494881',
    projectId: 'profrate-a38d5',
    authDomain: 'profrate-a38d5.firebaseapp.com',
    storageBucket: 'profrate-a38d5.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDf_Uqg934N4pVQqRQztywjZBmBqrp2Ec4',
    appId: '1:613778494881:android:cfa08fb06f509ccf6f27e0',
    messagingSenderId: '613778494881',
    projectId: 'profrate-a38d5',
    storageBucket: 'profrate-a38d5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDWP7QAQdV33mV34qRsz661nul6Tav2D1M',
    appId: '1:613778494881:ios:c1e66368ba3edcda6f27e0',
    messagingSenderId: '613778494881',
    projectId: 'profrate-a38d5',
    storageBucket: 'profrate-a38d5.appspot.com',
    iosClientId: '613778494881-ljsd042a6498q0t1vv11sdip91a51ugu.apps.googleusercontent.com',
    iosBundleId: 'com.example.modernlogintute',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDWP7QAQdV33mV34qRsz661nul6Tav2D1M',
    appId: '1:613778494881:ios:c1e66368ba3edcda6f27e0',
    messagingSenderId: '613778494881',
    projectId: 'profrate-a38d5',
    storageBucket: 'profrate-a38d5.appspot.com',
    iosClientId: '613778494881-ljsd042a6498q0t1vv11sdip91a51ugu.apps.googleusercontent.com',
    iosBundleId: 'com.example.modernlogintute',
  );
}
