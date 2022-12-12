import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:ghiles_flutter_fire_tp/screens/consultation.dart';
import 'package:ghiles_flutter_fire_tp/services/firestore.dart';
import 'package:ghiles_flutter_fire_tp/shared/widgets/CustomDrawer.dart';

import '../models/task.dart';
import 'creation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(title: const Text("Accueil")),
        body: StreamBuilder(
          stream: DataRepository.userTasksCollectionStream,
          builder: (context, AsyncSnapshot<QuerySnapshot<Task>> snapshot) {
            if (snapshot.hasError) return const Text('Something went wrong');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (!snapshot.hasData) return const Text('No Data available');
            List<Task> tasks = snapshot.data!.docs.map((e) {
              //print(e.data().toString());
              return e.data();
            }).toList();
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, i) {
                return ListTile(
                  //TODO: Display the task
                  title: Text(tasks[i].name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ConsultationScreen(task: tasks[i]),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        floatingActionButton:  FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CreationScreen(),
              ),
            );
          },
          child: Icon(Icons.add),
        ));
  }
}
