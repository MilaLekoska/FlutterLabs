import 'package:flutter/material.dart';
import 'dart:math';

import 'package:lab_196052/Models/exam.dart';
import 'package:lab_196052/Widgets/adaptiveAddButton.dart';

class NewExam extends StatefulWidget {
  final Function addExam;

  NewExam(this.addExam);
  @override
  State<StatefulWidget> createState() => _NewExamState();
}

class _NewExamState extends State<NewExam> {
  final _courseController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  late String course;
  late DateTime date;
  late DateTime time;

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
  }

  void _submitData() {
    if (_courseController.text.isEmpty) {
      return;
    }
    final enteredCourse = _courseController.text;

      final enteredDate = DateTime.parse(_dateController.text);

      final enteredTime = DateTime.parse(_timeController.text);

    if (enteredCourse.isEmpty) {
      return;
    }

    final newExam = Exam(id: generateRandomString(5), course: enteredCourse, date: enteredDate, time: enteredTime);
    widget.addExam(newExam);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TextField(
            controller: _courseController,
            decoration: InputDecoration(labelText: "Course"),
             // onChanged: (val) {
             //   course = val;
             // },
            onSubmitted: (_) => _submitData(),
          ),
          TextField(
            controller: _dateController,
            decoration: InputDecoration(labelText: "Exam Date"),
            keyboardType: TextInputType.datetime,
             // onChanged: (val) {
             //   date = DateTime.parse(val);
             // },
            onSubmitted: (_) => _submitData(),
          ),
          TextField(
            controller: _timeController,
            decoration: InputDecoration(labelText: "Exam Time"),
            keyboardType: TextInputType.datetime,
            onChanged: (val) {
              time = DateTime.parse(val);
            },
            onSubmitted: (_) => _submitData(),
          ),
          Button("Add", _submitData)
        ],
      ),
    );
  }
}