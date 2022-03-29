import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get webPlatFormConfig {
      return const FirebaseOptions(
          apiKey: "AIzaSyC0rsVyMMTxoegDFjQlrLALM9poBE4znAA",
          authDomain: "my-osc-finance.firebaseapp.com",
          projectId: "my-osc-finance",
          storageBucket: "my-osc-finance.appspot.com",
          messagingSenderId: "636466031264",
          appId: "1:636466031264:web:d14ae45f0d40583d2677c5",
          measurementId: "G-M5P8YC3M55"
      );
  }
}