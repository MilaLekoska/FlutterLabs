import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'adaptiveAddButton.dart';

class SignIn extends StatelessWidget {

  Future<void> _signIn() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Center(
        child: Button(
         'Sign In',
          _signIn,
        ),
      ),
    );
  }
}