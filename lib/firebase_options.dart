
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBZp9AuKh9bjCbOfB9PdTlNKQ5eRhOIbqg',
    appId: '1:476144516049:web:12f575f6bc5b0c10bc7ef0',
    messagingSenderId: '476144516049',
    projectId: 'lugnload-d5f7c',
    authDomain: 'lugnload-d5f7c.firebaseapp.com',
    databaseURL: 'https://lugnload-d5f7c-default-rtdb.firebaseio.com',
    storageBucket: 'lugnload-d5f7c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC0hdyn95vA3A3rSzXQhVX7Kiz0O8IICbw',
    appId: '1:476144516049:android:999a7ef88de132e9bc7ef0',
    messagingSenderId: '476144516049',
    projectId: 'lugnload-d5f7c',
    databaseURL: 'https://lugnload-d5f7c-default-rtdb.firebaseio.com',
    storageBucket: 'lugnload-d5f7c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCCJzc9b4EBpYRTfD-6daH1MJt_Bfyc1ec',
    appId: '1:476144516049:ios:76778c98aaef314bbc7ef0',
    messagingSenderId: '476144516049',
    projectId: 'lugnload-d5f7c',
    databaseURL: 'https://lugnload-d5f7c-default-rtdb.firebaseio.com',
    storageBucket: 'lugnload-d5f7c.appspot.com',
    iosBundleId: 'com.example.lugnload',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCCJzc9b4EBpYRTfD-6daH1MJt_Bfyc1ec',
    appId: '1:476144516049:ios:76778c98aaef314bbc7ef0',
    messagingSenderId: '476144516049',
    projectId: 'lugnload-d5f7c',
    databaseURL: 'https://lugnload-d5f7c-default-rtdb.firebaseio.com',
    storageBucket: 'lugnload-d5f7c.appspot.com',
    iosBundleId: 'com.example.lugnload',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBZp9AuKh9bjCbOfB9PdTlNKQ5eRhOIbqg',
    appId: '1:476144516049:web:70dc538d00bf28f9bc7ef0',
    messagingSenderId: '476144516049',
    projectId: 'lugnload-d5f7c',
    authDomain: 'lugnload-d5f7c.firebaseapp.com',
    databaseURL: 'https://lugnload-d5f7c-default-rtdb.firebaseio.com',
    storageBucket: 'lugnload-d5f7c.appspot.com',
  );
}
