import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final Function onClickHandler;

  Button(this.title, this.onClickHandler);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Text(title),
      onPressed: onClickHandler(),
    );
  }
}