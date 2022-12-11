import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ghiles_flutter_fire_tp/models/task.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';

import 'package:flutter/material.dart';

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
    return MaterialApp(
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
              GoogleProviderConfiguration(
                clientId: '824606719749-c8uhla2rp4h45d69os4uohndts174re8.apps.googleusercontent.com',
              )
            ],
          );
        }
        //user is signedin

        //check if user has a document, if not create one.
        return HomePage();
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> _usersCo =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Accueil")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .withConverter<Task>(
              fromFirestore: (snapshot, _) => Task.fromJson(snapshot.data()!),
              toFirestore: (task, _) => task.toJson(),
            )
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

         return ListView(
           children: snapshot.data!.docs.map((e) {
             print(e.data());
             return Text(e.id);
           }).toList(),
         );
          return Text('ddd');
        },
      ),
      floatingActionButton: const SignOutButton(),
    );
  }
}

class SignInWithGoogle extends StatelessWidget {
  const SignInWithGoogle({Key? key}) : super(key: key);

  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    var a = await FirebaseAuth.instance.signInWithCredential(credential);

    return a;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: _signInWithGoogle, child: Text('Sign in with GOOGLE'));
  }
}
