import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:developer';
part 'task.g.dart';

@JsonSerializable()
class Task {
  String? id;
  String name;
  num pourcentageAvancement;
  String userId;
  DateTime start;
  DateTime end;

  Task(
    this.name,
    this.start,
    this.end,
    this.pourcentageAvancement,
    this.userId,
  );

  Task.fromJson(Map<String, dynamic> json, String documentId)
      : id = documentId,
        name = json['name'],
        pourcentageAvancement = json['pourcentageAvancement'],
        userId = json['userId'],
        start = (json['start']).toDate(),
        end = (json['end']).toDate();

  Map<String, dynamic> toJson() => {
        'name': name,
        'pourcentageAvancement': pourcentageAvancement,
        'userId': userId,
        'start': start,
        'end': end,
      };

  @override
  String toString() {
    // TODO: implement toString
    return '{ id: $id, userId: $userId, name: $name, avancement: $pourcentageAvancement, start: $start, end: $end }';
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  /// factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  /// Map<String, dynamic> toJson() => _$TaskToJson(this);

}
