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
    apiKey: 'AIzaSyCKwCMYyIdjBIG-wsFKN_HaWQN-zfV1xiU',
    appId: '1:57805998364:web:3fd65452ab5597464e12d9',
    messagingSenderId: '57805998364',
    projectId: 'astrid-81209',
    authDomain: 'astrid-81209.firebaseapp.com',
    storageBucket: 'astrid-81209.appspot.com',
    measurementId: 'G-C2CFKT7BDN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAMI1nXTgDZQO0D01dsqXT_uc1Ouo7DWNQ',
    appId: '1:57805998364:android:6a0e9392658e79214e12d9',
    messagingSenderId: '57805998364',
    projectId: 'astrid-81209',
    storageBucket: 'astrid-81209.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDoZ20RCphZoZQtwfly-snXZ-kJYTkzrZQ',
    appId: '1:57805998364:ios:e8e0a34cc9642a3e4e12d9',
    messagingSenderId: '57805998364',
    projectId: 'astrid-81209',
    storageBucket: 'astrid-81209.appspot.com',
    androidClientId: '57805998364-0sdeethqvmjr8t5odu7t8g7k12g8mean.apps.googleusercontent.com',
    iosClientId: '57805998364-1pno4vol8ekeavh8rm9mt4mgd6rsovfa.apps.googleusercontent.com',
    iosBundleId: 'com.example.reservationApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDoZ20RCphZoZQtwfly-snXZ-kJYTkzrZQ',
    appId: '1:57805998364:ios:e8e0a34cc9642a3e4e12d9',
    messagingSenderId: '57805998364',
    projectId: 'astrid-81209',
    storageBucket: 'astrid-81209.appspot.com',
    androidClientId: '57805998364-0sdeethqvmjr8t5odu7t8g7k12g8mean.apps.googleusercontent.com',
    iosClientId: '57805998364-1pno4vol8ekeavh8rm9mt4mgd6rsovfa.apps.googleusercontent.com',
    iosBundleId: 'com.example.reservationApp',
  );
}
