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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAXx1Y9KPafGtty6kkSTNlf7yDeUYxRZZw',
    appId: '1:343129270576:android:22bd37b5349fcc486900f5',
    messagingSenderId: '343129270576',
    projectId: 'luthfullahi-new',
    storageBucket: 'luthfullahi-new.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAECXOmRrpZSPdYOpih9AtSNtqLeiFHyes',
    appId: '1:343129270576:ios:5fe155bd8c7cc9796900f5',
    messagingSenderId: '343129270576',
    projectId: 'luthfullahi-new',
    storageBucket: 'luthfullahi-new.appspot.com',
    androidClientId: '343129270576-hcsm0ji3cjc4lfndacu8s0r3mgk05lor.apps.googleusercontent.com',
    iosClientId: '343129270576-gj40d9de6rkg0q00bct8p8cea8hof4tc.apps.googleusercontent.com',
    iosBundleId: 'com.octramarket.luthfullahiApp',
  );
}
