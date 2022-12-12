import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as cloud_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ghiles_flutter_fire_tp/services/firestore.dart';
import 'package:ghiles_flutter_fire_tp/shared/widgets/CustomDrawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class ConsultationScreen extends StatefulWidget {
  ConsultationScreen({Key? key, required this.task}) : super(key: key);
  Task task;

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) {
        return setState(() => this.image = null);
      }
      setState(() => this.image = File(image.path));
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Consultation'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: displayImageWidget(widget.task)),
              ElevatedButton(
                  onPressed: pickImage, child: const Text('Choisir une image')),
              Text('Tâche: ${widget.task.name}'),
              Text(
                  'Début: ${DateFormat.yMMMMEEEEd().format(widget.task.start)}'),
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
              ElevatedButton(child: Text('Sauvegarder'), onPressed: SaveTask)
            ],
          ),
        ),
      ),
    );
  }

  Widget displayImageWidget(Task task) {
    if (image == null) {
      return task.photoUrl == null
          ? const Center(child: Text('Aucune image'))
          : Image.network(
              task.photoUrl!,
              fit: BoxFit.cover,
            );
    }
    return Image.file(
      image!,
      fit: BoxFit.cover,
    );
  }

  SaveTask() async {
    //Check if a new image was selected
    if (image != null) {
      //get the image ref (using the task unique id)
      final storageImageRef =
          cloud_storage.FirebaseStorage.instance.ref('${widget.task.id}');

      // upload the file  to cloud storage
      try {
        await storageImageRef.putFile(image!);
        //if successful, update the task's photoURL to the new uploaded image
        widget.task.photoUrl = await storageImageRef.getDownloadURL();
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur: ${e.message}'),
        ));
      }
    }

    // just save the updated task
    print(widget.task.toString());
    DataRepository.updateTask(widget.task).then((value) {
      print('SUCCESSFULLY UPDATED TASK ${widget.task.id}');
      Navigator.pop(context);
    }).catchError((err) {
      print('ERROR UPDATING TASK ${widget.task.id}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur: $err'),
      ));
    });
  }
}
