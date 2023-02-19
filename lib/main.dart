import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:lab_196052/Models/exam.dart';
import 'package:lab_196052/Widgets/newExam.dart';
import 'Widgets/adaptiveAddButton.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Exams App',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Exam> _exams = [
    Exam(id: "C1", course: "Calculus", date: DateTime.now(), time: DateTime.now()),
    Exam(id: "C2", course: "Discrete Mathematics", date: DateTime.now(), time: DateTime.now()),
  ];

  void _addNewToList(Exam exam) {
    setState(() {
      _exams.add(exam);
    });
  }

  void _addExamFunc(BuildContext ct) {
    // var newExam = Exam(id: "C3", course: "Test", date: DateTime.now(), time: DateTime.now());

    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(onTap: () {}, behavior: HitTestBehavior.opaque, child: NewExam(_addNewToList));
        });
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }


  Widget _createBody() {
    return Center(
      child: _exams.isEmpty
          ? Text("No courses")
          : ListView.builder(
        itemBuilder: (ctx, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 10,
            ),
            child: ListTile(
              title: Text(_exams[index].course),
              subtitle: Text("${_exams[index].time} ${_exams[index].date}")
            ),
          );
        },
        itemCount: _exams.length,
      ),
    );
  }

  PreferredSizeWidget _createAppBar() {
    return AppBar(
      // The title text which will be shown on the action bar
        title: Text("Courses"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addExamFunc(context),
          ),
          Button(
              'Logout',
             _signOut,
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(),
      body: _createBody(),
    );
  }
}
