import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_snap/config.dart';
import 'package:just_snap/data/classifier_handler.dart';
import 'package:just_snap/data/history_handler.dart';
import '../lists.dart';
import 'package:just_snap/model.dart';
import 'challenge.dart';
import 'package:just_snap/globals.dart' as globals;

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
          final item = ChallengeItem(items[items.length - index - 1]);
          return ListTile(
            title: item.buildTitle(context),
            subtitle: item.buildSubtitle(context),
            onTap: () => showDialog(
                context: context,
                builder: (_) => imageDialog(
                    items[items.length - index - 1].prompt,
                    '${globals.documentsPath}/$IMAGES_PATH/${items.length}.jpg',
                    context)),
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
          setState(() {});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget imageDialog(text, path, context) {
    return Dialog(
      // backgroundColor: Colors.transparent,
      // elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$text',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close_rounded),
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 220,
            height: 200,
            child: Image.memory(
              File('$path').readAsBytesSync(),
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
