import 'package:flutter/material.dart';
import 'package:ghiles_flutter_fire_tp/shared/widgets/CustomDrawer.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task.dart';
import '../services/firestore.dart';

class CreationScreen extends StatefulWidget {
  const CreationScreen({Key? key}) : super(key: key);

  @override
  State<CreationScreen> createState() => _CreationScreenState();
}

class _CreationScreenState extends State<CreationScreen> {

  DateTime? endDate;
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        endDate = picked;
        _endDateController.text = DateFormat('yyyy/MM/dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          title: const Text('Creation'),
        ),
        body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    controller: _taskNameController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.task),
                      labelText: 'Tâche',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a valid task name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _endDateController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_month),
                      labelText: 'Date finale',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please select a end date';
                      }
                      return null;
                    },
                    onTap: () async {
                      // Below line stops keyboard from appearing
                      FocusScope.of(context).requestFocus(new FocusNode());
                      // Show Date Picker Here
                      await _selectDate(context);


                    },
                  ),
                  ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: _submit,
                  ),
                ],
              ),
            )));
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      Task task = Task(
        _taskNameController.text.trim(),
        DateTime.now(),
        endDate!,
        0,
        FirebaseAuth.instance.currentUser!.uid,
      );

      print(task.toJson());

      //Task(this.name, this.start, this.end, this.pourcentageAvancement,this.userId);
      DataRepository.addTask(task).then((value) {
        print('SUCCESSFULLY ADDED TASK ');
        Navigator.pop(context);
      }).catchError((err) {
        print('ERROR ADDING TASK');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur: ${err}'),
        ));
      });
    }
  }
}
