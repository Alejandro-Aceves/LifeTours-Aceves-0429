// Archivo generado por FlutterFire CLI.
// Proyecto Firebase: bdtourscrud

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
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no están configuradas para esta plataforma.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCDWjLxNcFI4FxyqK_TEa4xuiJW4Ajk-OY',
    appId: '1:887612125656:web:4c861cfc008ab8a00682ad',
    messagingSenderId: '887612125656',
    projectId: 'bdtourscrud',
    authDomain: 'bdtourscrud.firebaseapp.com',
    storageBucket: 'bdtourscrud.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyARapFhchzT9bcERXzrAPffVAqTBDfY5e0',
    appId: '1:887612125656:android:8e3e0bdd76b89c580682ad',
    messagingSenderId: '887612125656',
    projectId: 'bdtourscrud',
    storageBucket: 'bdtourscrud.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCDWjLxNcFI4FxyqK_TEa4xuiJW4Ajk-OY',
    appId: '1:887612125656:web:4c861cfc008ab8a00682ad',
    messagingSenderId: '887612125656',
    projectId: 'bdtourscrud',
    authDomain: 'bdtourscrud.firebaseapp.com',
    storageBucket: 'bdtourscrud.firebasestorage.app',
  );
}