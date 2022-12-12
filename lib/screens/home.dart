import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:ghiles_flutter_fire_tp/shared/widgets/CustomDrawer.dart';

import '../models/task.dart';
import 'creation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<QuerySnapshot> _usersCo =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(title: const Text("Accueil")),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .where('userId',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .withConverter<Task>(
                fromFirestore: (snapshot, _) => Task.fromJson(snapshot.data()!),
                toFirestore: (task, _) => task.toJson(),
              )
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot<Task>> snapshot) {
            if (snapshot.hasError) return const Text('Something went wrong');
            if (snapshot.connectionState == ConnectionState.waiting)
              return const CircularProgressIndicator();
            if (!snapshot.hasData) return const Text('No Data available');
            List<Task> tasks = snapshot.data!.docs.map((e) {
              print(e.data().toJson());
              return e.data();
            }).toList();
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, i) {
                return ListTile(
                  //TODO: Display the task
                  title: Text(tasks[i].name),
                );
              },
            );
          },
        ),
        floatingActionButton: Stack(
          children: [
            Align(alignment: Alignment.bottomLeft, child: SignOutButton()),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreationScreen(),
                    ),
                  );
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        ));
  }
}
