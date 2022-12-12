import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';

import 'package:flutter/material.dart';

import 'screens/home.dart';

// Firebase not working with android emulator. Solution : downgrade emulator version.
// https://stackoverflow.com/questions/73370728/firebase-doesnt-work-on-android-studio-emulator/73932721
// https://developer.android.com/studio/emulator_archive

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //home: AddUser('adel', 'kouaou', 26),
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return SignInScreen(
            showAuthActionSwitch: false,
            headerBuilder: (context, constraints, _) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                      'https://firebase.flutter.dev/img/flutterfire_300x.png'),
                ),
              );
            },
            providerConfigs: [
              const GoogleProviderConfiguration(
                clientId:
                    '824606719749-c8uhla2rp4h45d69os4uohndts174re8.apps.googleusercontent.com',
              )
            ],
          );
        }

        // User is signed in
        return const HomeScreen();
      },
    );
  }
}
