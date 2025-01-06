import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey:
          "AIzaSyC2uXoyMoqIqyGcLlWwFv_Dmt2CDfjh4tI", // Replace with your Web API Key
      appId:
          "1:432498621858:android:18118b5a4e19e3a79586fb", // Replace with your App ID
      messagingSenderId: "432498621858", // Project number
      projectId: "campuslifeassistant-c19e1", // Project ID
      authDomain:
          "campuslifeassistant-c19e1.firebaseapp.com", // Optional, add if available
      storageBucket:
          "campuslifeassistant-c19e1.appspot.com", // Optional, add if available
    );
  }
}
