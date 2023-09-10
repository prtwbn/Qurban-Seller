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
    apiKey: 'AIzaSyBP_XhLMdpsIgkCpIZ_jGEdGGJVyYQgwGQ',
    appId: '1:214755552988:web:89dced6fea91fa3c564e19',
    messagingSenderId: '214755552988',
    projectId: 'qurban-76010',
    authDomain: 'qurban-76010.firebaseapp.com',
    storageBucket: 'qurban-76010.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAzJOahjntO8vOZE_McIcShAG_UYMEeJ6Q',
    appId: '1:214755552988:android:c680dd70fe114346564e19',
    messagingSenderId: '214755552988',
    projectId: 'qurban-76010',
    storageBucket: 'qurban-76010.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBY-0rarU__6wFIbq8hAD9R93L57uJdo9Q',
    appId: '1:214755552988:ios:9e4e1af70e1123d3564e19',
    messagingSenderId: '214755552988',
    projectId: 'qurban-76010',
    storageBucket: 'qurban-76010.appspot.com',
    iosClientId: '214755552988-4nqq7thmflnfj6b6ckorg5012rh7bh08.apps.googleusercontent.com',
    iosBundleId: 'com.example.qurbanSeller',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBY-0rarU__6wFIbq8hAD9R93L57uJdo9Q',
    appId: '1:214755552988:ios:9e4e1af70e1123d3564e19',
    messagingSenderId: '214755552988',
    projectId: 'qurban-76010',
    storageBucket: 'qurban-76010.appspot.com',
    iosClientId: '214755552988-4nqq7thmflnfj6b6ckorg5012rh7bh08.apps.googleusercontent.com',
    iosBundleId: 'com.example.qurbanSeller',
  );
}
