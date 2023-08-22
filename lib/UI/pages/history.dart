import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_snap/config.dart';
import 'package:just_snap/data/history_handler.dart';
import 'package:just_snap/data/language_handler.dart';
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
  final LanduageHandler _languageHandler = LanduageHandler();
  List<String>? _labels;

  Future<void> _loadLabels() async {
    _labels =
        (await rootBundle.loadString(_languageHandler.labelsPath)).split('\n');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_labels == null) {
      _loadLabels();
      return Scaffold(
          appBar: AppBar(
            title: Text(_languageHandler.historyText),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    _languageHandler.language =
                        _languageHandler.language == 'ru' ? 'en' : 'ru';
                    await _loadLabels();
                  },
                  child: Text(_languageHandler.language))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChallengePage(languageHandler: _languageHandler)));
              await _loadLabels();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add_a_photo),
          ));
    } else {
      List<Challenge> items = HistoryHandler().challenges;
      return Scaffold(
        appBar: AppBar(
          title: Text(_languageHandler.historyText),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  _languageHandler.language =
                      _languageHandler.language == 'ru' ? 'en' : 'ru';
                  await _loadLabels();
                },
                child: Text(_languageHandler.language))
          ],
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item =
                ChallengeItem(items[items.length - index - 1], _labels!);
            return ListTile(
              title: item.buildTitle(context),
              subtitle: item.buildSubtitle(context),
              onTap: () => showDialog(
                  context: context,
                  builder: (_) => imageDialog(
                      _labels![
                          int.parse(items[items.length - index - 1].prompt)],
                      '${globals.documentsPath}/$IMAGES_PATH/${items.length}.jpg',
                      context)),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChallengePage(
                          languageHandler: _languageHandler,
                        )));
            await _loadLabels();
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add_a_photo),
        ),
      );
    }
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
