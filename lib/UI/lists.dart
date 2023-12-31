import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:just_snap/model.dart';

abstract class ListItem {
  Widget buildTitle(BuildContext context);

  Widget buildSubtitle(BuildContext context);
}

class ChallengeItem implements ListItem {
  final Challenge challenge;
  final List<String> labels;

  ChallengeItem(this.challenge, this.labels);

  @override
  Widget buildTitle(BuildContext context) =>
      Text(labels[int.parse(challenge.prompt)]);

  @override
  Widget buildSubtitle(BuildContext context) =>
      Text(DateFormat('dd.MM.yy').format(challenge.dateTime.toLocal()));
}
