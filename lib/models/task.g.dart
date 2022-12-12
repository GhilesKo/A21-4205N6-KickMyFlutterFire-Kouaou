// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      json['name'] as String,
      DateTime.parse(json['start'] as String),
      DateTime.parse(json['end'] as String),
      json['pourcentageAvancement'] as num,
      json['userId'] as String,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'name': instance.name,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'pourcentageAvancement': instance.pourcentageAvancement,
      'userId': instance.userId,
    };
