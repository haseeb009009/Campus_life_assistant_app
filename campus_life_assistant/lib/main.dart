import 'package:campus_life_assistant/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    print("Firebase Initialization Error: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Campus Life Assistant',
            theme: ThemeData(primarySwatch: Colors.blue),
            home: const LoginPage(),
            routes: {
              '/signup': (context) => const SignUpPage(),
              '/login': (context) => const LoginPage(),
            },
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error initializing Firebase"));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
