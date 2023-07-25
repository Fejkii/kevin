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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDxhAYUgaUmdl3327QYJ0aYKi9VBULSKXk',
    appId: '1:325124044712:web:509c95a44428016c34cf9d',
    messagingSenderId: '325124044712',
    projectId: 'kevin-bc476',
    authDomain: 'kevin-bc476.firebaseapp.com',
    storageBucket: 'kevin-bc476.appspot.com',
    measurementId: 'G-9NXQ02XS6E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDbYYR72j4s8jnGwYn46swABElUibTN_z0',
    appId: '1:325124044712:android:54e6e1ba2e91d37634cf9d',
    messagingSenderId: '325124044712',
    projectId: 'kevin-bc476',
    storageBucket: 'kevin-bc476.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCiqotD38xaLebpFPhTmSEp7o7KBX0aJtg',
    appId: '1:325124044712:ios:6a308133cf7a4d3334cf9d',
    messagingSenderId: '325124044712',
    projectId: 'kevin-bc476',
    storageBucket: 'kevin-bc476.appspot.com',
    iosClientId: '325124044712-tgg6o6qpdcgr1h2tjh6oqtuvo9fk6nfd.apps.googleusercontent.com',
    iosBundleId: 'com.example.kevin',
  );
}