import 'package:flutter/material.dart';
import 'package:just_snap/data/classifier_handler.dart';
import 'package:just_snap/data/history_handler.dart';
import '../lists.dart';
import 'package:just_snap/model.dart';
import 'challenge.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    List<Challenge> items = HistoryHandler().challenges;
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = ChallengeItem(items[index]);
          return ListTile(
            title: item.buildTitle(context),
            subtitle: item.buildSubtitle(context),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ClassifierHandler classifierHandler = ClassifierHandler();
          await classifierHandler.load();
          // ignore: use_build_context_synchronously
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChallengePage(
                        classifierHandler: classifierHandler,
                      )));
          classifierHandler.unload();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
