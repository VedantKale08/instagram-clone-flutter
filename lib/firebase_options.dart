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
    apiKey: 'AIzaSyA-zt0q4AaNFDcYOWjDP9XYO4Pe6m2NrGg',
    appId: '1:907407832446:web:55d70b39e09770c14baf2f',
    messagingSenderId: '907407832446',
    projectId: 'instagram-clone-fcdfb',
    authDomain: 'instagram-clone-fcdfb.firebaseapp.com',
    storageBucket: 'instagram-clone-fcdfb.appspot.com',
    measurementId: 'G-GW4B1VHC1G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBewb27ZIZTOR9AnTlALbciCY7K8_F3v2o',
    appId: '1:907407832446:android:a6d0ffcba65ad29e4baf2f',
    messagingSenderId: '907407832446',
    projectId: 'instagram-clone-fcdfb',
    storageBucket: 'instagram-clone-fcdfb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCYftmEMZAv5t9vYaO7Y00qoG4CGPvCb6E',
    appId: '1:907407832446:ios:4145d041893dae9b4baf2f',
    messagingSenderId: '907407832446',
    projectId: 'instagram-clone-fcdfb',
    storageBucket: 'instagram-clone-fcdfb.appspot.com',
    iosBundleId: 'com.example.instagramClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCYftmEMZAv5t9vYaO7Y00qoG4CGPvCb6E',
    appId: '1:907407832446:ios:d84e0574c6e62fba4baf2f',
    messagingSenderId: '907407832446',
    projectId: 'instagram-clone-fcdfb',
    storageBucket: 'instagram-clone-fcdfb.appspot.com',
    iosBundleId: 'com.example.instagramClone.RunnerTests',
  );
}
