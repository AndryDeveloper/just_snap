class Challenge {
  final int challengeId;
  final String prompt;
  final DateTime dateTime;

  const Challenge(this.challengeId, this.prompt, this.dateTime);

  @override
  String toString() {
    return '$challengeId,$prompt,${dateTime.millisecondsSinceEpoch ~/ 1000}';
  }
}
