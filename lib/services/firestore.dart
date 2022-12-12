import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ghiles_flutter_fire_tp/services/authentication.dart';

import '../models/task.dart';

class DataRepository {
  static final _fireStore = FirebaseFirestore.instance;

  //Référence à la collection des task dans firestore utilisé pour CRUD operations
  static CollectionReference<Task> get _taskCollectionRef =>
      _fireStore.collection('tasks').withConverter<Task>(
            fromFirestore: (snapshot, _) => Task.fromJson(
              snapshot.data()!,
              snapshot.id,
            ),
            toFirestore: (task, _) => task.toJson(),
          );


  //Référence à la collection des task de L'UTILISATEUR (query)  dans firestore utilisé pour STREAM les données dans la home page
  static Stream<QuerySnapshot<Task>> get userTasksCollectionStream => _fireStore
      .collection('tasks')
      .where('userId', isEqualTo: AuthService.user!.uid)
      .withConverter<Task>(
        fromFirestore: (snapshot, _) => Task.fromJson(
          snapshot.data()!,
          snapshot.id,
        ),
        toFirestore: (task, _) => task.toJson(),
      ).snapshots();

  static Future<DocumentReference<Task>> addTask(Task task) =>
      _taskCollectionRef.add(task);

  static Future<void> updateTask(Task task) =>
      _taskCollectionRef.doc(task.id).set(task);
}
