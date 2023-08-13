import 'config.dart';

class Challenge {
  final int challengeId;
  final String prompt;
  final DateTime dateTime;

  const Challenge(this.challengeId, this.prompt, this.dateTime);

  @override
  String toString() {
    return '$challengeId$CSV_FIELD_DELIMITER$prompt$CSV_FIELD_DELIMITER${dateTime.millisecondsSinceEpoch ~/ 1000}';
  }
}