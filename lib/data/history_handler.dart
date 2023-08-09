import 'dart:io';
import 'package:just_snap/model.dart';
import 'package:csv/csv.dart';

class HistoryHandler {
  late List<Challenge> _challenges;

  HistoryHandler() {
    final rawData = File('assets/history.csv').readAsStringSync();
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
    _challenges = [];
    for (var el in listData) {
      _challenges.add(Challenge(
          el[0], el[1], DateTime.fromMillisecondsSinceEpoch(el[2] * 1000)));
    }
  }

  List<Challenge> get challenges => _challenges;
}
