import 'dart:io';
import 'package:just_snap/model.dart';
import 'package:csv/csv.dart';

class HistoryHandler {
  late List<Challenge> _challenges;
  late File _historyFile;

  HistoryHandler() {
    _historyFile = File('assets/history.csv');
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

  void addEntry(Challenge el) {
    _challenges.add(el);
    _historyFile.writeAsStringSync('$el\n', mode: FileMode.append);
  }

  List<Challenge> get challenges => _challenges;
}
