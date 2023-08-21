import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LockWinWidget extends StatelessWidget {
  final int secondsLeft;

  const LockWinWidget({required this.secondsLeft, super.key});

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
        textAlign: TextAlign.center,
        'You have already photographed the desired item,\nthe next one will appear in\n$dateFormat');
  }
}

class LockLoseWidget extends StatelessWidget {
  final int secondsLeft;
  final String guessedWord;
  final Widget button;
  final String prompt;

  const LockLoseWidget(
      {required this.prompt,
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
          'Sorry, but we think you took a photo of the $guessedWord,\ninstead of $prompt,\nyou can try again in\n$dateFormat'),
      button
    ]);
  }
}
