import 'package:flutter/material.dart';
import 'package:just_snap/globals.dart' as globals;


class MyTimer extends StatelessWidget {
  final Widget child;
  final String name;
  bool forceShowChild;
  late int secondsLeft;

  MyTimer({required this.secondsLeft, required this.child, required this.name, required this.forceShowChild, super.key});

  @override
  Widget build(BuildContext context) {
    if (forceShowChild || !globals.timerHandler.checkTimer(name)) {
      return child;
    } else {
      return Text('$secondsLeft');
    }
  }
}


