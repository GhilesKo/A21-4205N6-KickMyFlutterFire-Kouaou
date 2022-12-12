import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataRepository {
  static final _fireStore = FirebaseFirestore.instance;


  static _taskCollectionRef() =>
      _fireStore.collection('tasks').withConverter<Task>(
            fromFirestore: (snapshot, _) => Task.fromJson(snapshot.data()!),
            toFirestore: (task, _) => task.toJson(),
          );

  static Future<DocumentReference<Task>> addTask(Task task) =>
      _taskCollectionRef().add(task);
}
