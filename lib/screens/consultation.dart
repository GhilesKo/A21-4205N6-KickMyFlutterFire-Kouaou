import 'package:flutter/material.dart';
import 'package:ghiles_flutter_fire_tp/services/firestore.dart';
import 'package:ghiles_flutter_fire_tp/shared/widgets/CustomDrawer.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class ConsultationScreen extends StatefulWidget {
  ConsultationScreen({Key? key, required this.task}) : super(key: key);
  Task task;

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Consultation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Tâche: ${widget.task.name}'),
            Text('Début: ${DateFormat.yMMMMEEEEd().format(widget.task.start)}'),
            Text('Fin: ${DateFormat.yMMMMEEEEd().format(widget.task.start)}'),
            Text(
                'Pourcentage avancement: ${widget.task.pourcentageAvancement.round()}%'),
            Slider(
              value: widget.task.pourcentageAvancement.toDouble(),
              max: 100,
              divisions: 100,
              label: widget.task.pourcentageAvancement
                  .toDouble()
                  .round()
                  .toString(),
              onChanged: (double value) {
                setState(() {
                  widget.task.pourcentageAvancement = value;
                });
              },
            ),
            ElevatedButton(
              child: Text('Sauvegarder'),
              onPressed: () {
                print(widget.task.toString());
                DataRepository.updateTask(widget.task).then((value) {
                  print('SUCCESSFULLY UPDATED TASK ${widget.task.id}');
                  Navigator.pop(context);
                }).catchError((err) {
                  print('ERROR UPDATING TASK ${widget.task.id}');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Erreur: ${err}'),
                  ));
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
