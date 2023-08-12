import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:just_snap/data/classifier_handler.dart';
import 'package:just_snap/data/history_handler.dart';
import '../../config.dart';
import '../../data/prompt_handler.dart';
import 'package:image_picker/image_picker.dart';
import '../../globals.dart' as globals;

class ChallengePage extends StatefulWidget {
  late final ClassifierHandler _classifierHandler;

  ChallengePage({super.key, required classifierHandler}) {
    _classifierHandler = classifierHandler;
  }

  @override
  // ignore: no_logic_in_create_state
  State<ChallengePage> createState() => _ChallengePageState(_classifierHandler);
}

class _ChallengePageState extends State<ChallengePage> {
  final PromptHandler _promptHandler = PromptHandler();
  final HistoryHandler _historyHandler = HistoryHandler();
  final ImagePicker _picker = ImagePicker();
  late final ClassifierHandler _classifierHandler;
  String _prompt = PROMPT_PLACEHOLDER;
  Uint8List? _imageBytes;

  _ChallengePageState(classifierHandler) {
    _classifierHandler = classifierHandler;
  }

  void _submitChallenge() async {
    String prediction = await _classifierHandler
        .predict('${globals.documentsPath}/$TEMP_IMAGE_FNAME');
    if (prediction == _prompt) {
      _historyHandler.addEntry(_prompt);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      // ignore: avoid_print
      print('wrong picture, predicted "$prediction"');
    }
  }

  Future<void> _chooseImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await image.saveTo('${globals.documentsPath}/$TEMP_IMAGE_FNAME');
      setState(() {
        _imageBytes = File('${globals.documentsPath}/$TEMP_IMAGE_FNAME')
            .readAsBytesSync();
      });
    }
  }

  Future<void> _getChallengePrompt() async {
    String prompt = await _promptHandler.generatePrompt();
    setState(() => _prompt = prompt);
  }

  @override
  Widget build(BuildContext context) {
    if (_prompt == PROMPT_PLACEHOLDER) {
      _getChallengePrompt();
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Load your picture'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                  onTap: _chooseImage,
                  child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: ((_imageBytes != null)
                              ? <Widget>[
                                  Image.memory(_imageBytes!,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              CHALLENGE_IMAGE_REL_HEIGHT,
                                      fit: BoxFit.contain)
                                ]
                              : <Widget>[]) +
                          [
                            Icon(
                              Icons.add_a_photo,
                              size: MediaQuery.of(context).size.width *
                                  PHOTO_ICON_REL_SIZE,
                              color:
                                  Colors.black.withOpacity(PHOTO_ICON_OPACITY),
                            ),
                          ])),
              Column(
                children: [
                  const Text('Take a photo:'),
                  Text(_prompt),
                ],
              ),
              TextButton(
                  onPressed: () => _submitChallenge(),
                  child: const Text('Send'))
            ],
          ),
        ));
  }
}
