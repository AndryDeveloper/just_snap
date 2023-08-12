import 'dart:io';
import 'package:just_snap/config.dart';
import 'package:just_snap/model.dart';
import 'package:csv/csv.dart';
import '../globals.dart' as globals;

class HistoryHandler {
  late List<Challenge> _challenges;
  late File _historyFile;

  HistoryHandler() {
    _historyFile = File('${globals.documentsPath}/$CHALLENGE_HISTORY_FNAME');
    _challenges = [];
    if (!_historyFile.existsSync()) {
      _historyFile.createSync();
    } else {
      final rawData = _historyFile.readAsStringSync();
      List<List<dynamic>> listData =
          const CsvToListConverter(eol: '\n').convert(rawData);
      for (var el in listData) {
        _challenges.add(Challenge(
            el[0], el[1], DateTime.fromMillisecondsSinceEpoch(el[2] * 1000)));
      }
    }
  }

  void addEntry(String prompt) {
    Challenge challenge =
        Challenge(_challenges.length, prompt, DateTime.now().toUtc());
    _challenges.add(challenge);
    _historyFile.writeAsStringSync('$challenge\n', mode: FileMode.append);
  }

  List<Challenge> get challenges => _challenges;
}
