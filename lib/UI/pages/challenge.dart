import 'package:flutter/material.dart';
import '../../config.dart';
import 'dart:io';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  void _submitChallenge() {}
  void _chooseImage() {}
  String _challengePrompt() {
    return 'абебе';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Load your pic'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: _chooseImage,
                  child: Stack(children: [
                // Image.file(File('assets/1.jpg')),
                Center(
                    child: Icon(Icons.add_a_photo,
                        size: MediaQuery.of(context).size.width *
                            PHOTO_ICON_REL_SIZE))
              ])),
              Column(
                children: [
                  const Text('Take a photo:'),
                  Text(_challengePrompt()),
                ],
              ),
              TextButton(
                  onPressed: () => _submitChallenge(), child: const Text('Send'))
            ],
          ),
        ));
  }
}
