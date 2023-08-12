import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:just_snap/config.dart';
import '../globals.dart' as globals;

class PromptHandler {
  late final File _promptFile;
  late final Random _randomGenerator;
  List<String>? _labels;

  PromptHandler() {
    _promptFile = File('${globals.documentsPath}/prompt.txt');
    if (!_promptFile.existsSync()) {
      _promptFile.createSync();
    }
    _randomGenerator = Random();
  }

  Future<String> generatePrompt() async {
    _labels ??= (await rootBundle.loadString(LABELS_PATH)).split('\n');
    if (_promptFile.lengthSync() == 0) {
      String prompt = _labels![_randomGenerator.nextInt(_labels!.length)];
      DateTime now = DateTime.now().toUtc();
      _promptFile.writeAsStringSync(
          '${DateTime(now.year, now.month, now.day).millisecondsSinceEpoch ~/ 1000}\n$prompt');
      return prompt;
    } else {
      List<String> data = _promptFile.readAsLinesSync();
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(data[0]) * 1000);
      DateTime date = DateTime(dateTime.year, dateTime.month, dateTime.day);
      String currentPrompt = data[1];
      DateTime currentDateTime = DateTime.now().toUtc();
      DateTime currentDate = DateTime(
          currentDateTime.year, currentDateTime.month, currentDateTime.day);
      if (date.isBefore(currentDate)) {
        String prompt = _labels![_randomGenerator.nextInt(_labels!.length)];
        DateTime now = DateTime.now().toUtc();
        _promptFile.writeAsStringSync(
            '${DateTime(now.year, now.month, now.day).millisecondsSinceEpoch ~/ 1000}\n$prompt');
        return prompt;
      } else {
        return currentPrompt;
      }
    }
  }
}
