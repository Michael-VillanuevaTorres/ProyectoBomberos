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
    apiKey: 'AIzaSyBhKmLqZr0i6pYvTkp-Ht7m3W9ff72FvCw',
    appId: '1:1008603092232:web:8ea0f39ab92797a31108bd',
    messagingSenderId: '1008603092232',
    projectId: 'rfecc-6bf47',
    authDomain: 'rfecc-6bf47.firebaseapp.com',
    storageBucket: 'rfecc-6bf47.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCTc1ZRhqRLcufpr70waHowJ2szInwqBSA',
    appId: '1:1008603092232:android:7a6c743d72e235a81108bd',
    messagingSenderId: '1008603092232',
    projectId: 'rfecc-6bf47',
    storageBucket: 'rfecc-6bf47.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCQzG8gOiB7YstFvGmjkyjsVJSZYUrq0KQ',
    appId: '1:1008603092232:ios:d3d7371ebf19dd131108bd',
    messagingSenderId: '1008603092232',
    projectId: 'rfecc-6bf47',
    storageBucket: 'rfecc-6bf47.appspot.com',
    iosBundleId: 'com.example.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCQzG8gOiB7YstFvGmjkyjsVJSZYUrq0KQ',
    appId: '1:1008603092232:ios:ad10989be7626a941108bd',
    messagingSenderId: '1008603092232',
    projectId: 'rfecc-6bf47',
    storageBucket: 'rfecc-6bf47.appspot.com',
    iosBundleId: 'com.example.app.RunnerTests',
  );
}
