import 'package:flutter/cupertino.dart';

class Exam {
  final String id;
  final String course;
  final DateTime date;
  final DateTime time;

  Exam({
    required this.id,
    required this.course,
    required this.date,
    required this.time
  });
}