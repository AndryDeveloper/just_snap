import 'package:flutter/material.dart';
import 'package:just_snap/globals.dart' as globals;

class MyTimer extends StatelessWidget {
  final (Widget, Widget) children;
  final String name;
  final bool forceShowChild;

  const MyTimer(
      {required this.children,
      required this.name,
      required this.forceShowChild,
      super.key});

  @override
  Widget build(BuildContext context) {
    if (forceShowChild || !globals.timerHandler.checkTimer(name)) {
      return children.$1;
    } else {
      return children.$2;
    }
  }
}
