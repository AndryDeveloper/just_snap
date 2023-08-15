import 'package:flutter/material.dart';

class LockWinWidget extends StatelessWidget {
  final int secondsLeft;

  const LockWinWidget({required this.secondsLeft, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
        textAlign: TextAlign.center,
        'You have already photographed the desired item,\nthe next one will appear in\n${secondsLeft ~/ 3600}:${secondsLeft ~/ 60 % 60}:${secondsLeft % 60 % 60}');
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
    return Column(children: [
      Text(
          textAlign: TextAlign.center,
          'Sorry, but we think you took a photo of the $guessedWord,\ninstead of $prompt,\nyou can try again in\n${secondsLeft ~/ 3600}:${secondsLeft ~/ 60 % 60}:${secondsLeft % 60 % 60},\nor you can wath an ad'),
      button
    ]);
  }
}
