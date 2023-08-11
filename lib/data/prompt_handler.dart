import 'dart:io';
import "dart:math";

class PromptHandler{
  late File _promptFile;
  late final List<String> _labels;
  late final Random _randomGenerator;

  String generatePrompt() {
    if (_promptFile.lengthSync() == 0) {
      String prompt = _labels[_randomGenerator.nextInt(_labels.length)];
      DateTime now = DateTime.now().toUtc();
      _promptFile.writeAsStringSync('${DateTime(now.year, now.month, now.day).millisecondsSinceEpoch ~/ 1000}\n$prompt');
      return prompt;
      
    } else {
      List<String> data = _promptFile.readAsLinesSync();
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(data[0]) * 1000);
      DateTime date = DateTime(dateTime.year, dateTime.month, dateTime.day);
      String currentPrompt = data[1];
      DateTime currentDateTime = DateTime.now().toUtc();
      DateTime currentDate = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day);
      if (date.isBefore(currentDate)) {
        String prompt = _labels[_randomGenerator.nextInt(_labels.length)];
        DateTime now = DateTime.now().toUtc();
        _promptFile.writeAsStringSync('${DateTime(now.year, now.month, now.day).millisecondsSinceEpoch ~/ 1000}\n$prompt');
        return prompt;
      } else {
        return currentPrompt;
      }

    }
  }

  PromptHandler() {
    _promptFile = File('assets/prompt.txt');
    if (!_promptFile.existsSync()) {
      _promptFile.createSync();
    }
    _labels = File('assets/imagenet22k_labels.txt').readAsLinesSync();
    _randomGenerator = Random();
  }

}
