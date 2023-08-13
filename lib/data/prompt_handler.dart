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
    _promptFile = File('${globals.documentsPath}/$PROMPT_FNAME');
    if (!_promptFile.existsSync()) _promptFile.createSync();
    _randomGenerator = Random();
  }

  Future<String> generatePrompt() async {
    if (_promptFile.lengthSync() == 0 ||
        !globals.timerHandler.checkTimer(PROMPT_TIMER)) {
      //Starting timer
      DateTime currentDateTime = DateTime.now().toUtc();
      DateTime currentDate = DateTime.utc(
          currentDateTime.year, currentDateTime.month, currentDateTime.day + 1);

      globals.timerHandler
          .createTimer(PROMPT_TIMER, currentDate.difference(currentDateTime));

      //Generate prompt
      _labels ??= (await rootBundle.loadString(LABELS_PATH)).split('\n');
      String prompt = _labels![_randomGenerator.nextInt(_labels!.length)];
      _promptFile.writeAsStringSync(prompt);
      return prompt;
    } else {
      return _promptFile.readAsStringSync();
    }
  }
}
