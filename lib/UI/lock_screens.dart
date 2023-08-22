import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_snap/data/language_handler.dart';

class LockWinWidget extends StatelessWidget {
  final int secondsLeft;
  final LanduageHandler landuageHandler;

  const LockWinWidget(
      {required this.landuageHandler, required this.secondsLeft, super.key});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(secondsLeft * 1000).toUtc();
    String dateFormat = '';
    if (dateTime.hour > 0) {
      dateFormat = DateFormat('hh:mm:ss').format(dateTime);
    } else if (dateTime.minute > 0) {
      dateFormat = DateFormat('mm:ss').format(dateTime);
    } else {
      dateFormat = DateFormat('ss').format(dateTime);
    }
    return Text(
        textAlign: TextAlign.center, landuageHandler.winTimerText(dateFormat));
  }
}

class LockLoseWidget extends StatelessWidget {
  final int secondsLeft;
  final String guessedWord;
  final Widget button;
  final String prompt;
  final LanduageHandler landuageHandler;

  const LockLoseWidget(
      {required this.landuageHandler,
      required this.prompt,
      required this.button,
      required this.guessedWord,
      required this.secondsLeft,
      super.key});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(secondsLeft * 1000).toUtc();
    String dateFormat = '';
    if (dateTime.hour > 0) {
      dateFormat = DateFormat('hh:mm:ss').format(dateTime);
    } else if (dateTime.minute > 0) {
      dateFormat = DateFormat('mm:ss').format(dateTime);
    } else {
      dateFormat = DateFormat('ss').format(dateTime);
    }
    return Column(children: [
      Text(
          textAlign: TextAlign.center,
          landuageHandler.loseTimerText(guessedWord, prompt, dateFormat)),
      button
    ]);
  }
}
