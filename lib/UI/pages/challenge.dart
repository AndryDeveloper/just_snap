import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:just_snap/UI/lock_screens.dart';
import 'package:just_snap/data/classifier_handler.dart';
import 'package:just_snap/data/history_handler.dart';
import '../../config.dart';
import '../../data/prompt_handler.dart';
import 'package:image_picker/image_picker.dart';
import '../../globals.dart' as globals;
import 'package:just_snap/UI/timer.dart';

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
  late bool forceShowPage;
  late int secondsLeftPage;
  late bool forceShowPic;
  late int secondsLeftPic;
  late StreamSubscription<InternetConnectionStatus> connectionListener;
  bool _isConnected = false;
  String _guessedWord = GUESSES_WORD_PLACEHOLDER;

  _ChallengePageState(classifierHandler) {
    forceShowPage = !_historyHandler.guessedToday();
    secondsLeftPage =
        globals.timerHandler.timerDuration(PROMPT_TIMER).inSeconds;
    forceShowPic = false;
    secondsLeftPic = globals.timerHandler.timerDuration(SEND_TIMER).inSeconds;
    _classifierHandler = classifierHandler;
  }

  @override
  void initState() {
    File tempFile = File('${globals.documentsPath}/$TEMP_IMAGE_FNAME');
    if (tempFile.existsSync()) {
      tempFile.deleteSync();
    }

    globals.timerHandler.addCallback(PROMPT_TIMER, (int p) {
      if (_historyHandler.guessedToday()) {
        setState(() {
          forceShowPage = !_historyHandler.guessedToday();
          secondsLeftPage = p;
        });
      }
    }, 0);
    globals.timerHandler.addCallback(
        SEND_TIMER,
        (int p) => setState(() {
              secondsLeftPic = p;
            }),
        1);

    connectionListener =
        InternetConnectionChecker().onStatusChange.listen((status) {
      setState(() {
        _isConnected = status == InternetConnectionStatus.connected;
      });
      _getChallengePrompt();
    });
    super.initState();
  }

  @override
  void dispose() {
    File tempFile = File('${globals.documentsPath}/$TEMP_IMAGE_FNAME');
    if (tempFile.existsSync()) {
      tempFile.deleteSync();
    }

    globals.timerHandler.removeCallback(PROMPT_TIMER, 0);
    globals.timerHandler.removeCallback(SEND_TIMER, 1);
    connectionListener.cancel();
    super.dispose();
  }

  void _submitChallenge() async {
    if (File('${globals.documentsPath}/$TEMP_IMAGE_FNAME').existsSync() &&
        !globals.timerHandler.checkTimer(SEND_TIMER)) {
      List<String> prediction = await _classifierHandler
          .predict('${globals.documentsPath}/$TEMP_IMAGE_FNAME');
      _guessedWord = prediction[0];
      if (prediction.contains(_prompt)) {
        _historyHandler.addEntry(_prompt);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        globals.timerHandler.createTimer(
            SEND_TIMER, const Duration(seconds: TIMER_DURATION_AFTER_FAIL));
      }
    }
  }

  Future<void> _chooseImage() async {
    final XFile? image = await _picker.pickImage(
        source: Platform.isWindows ? ImageSource.gallery : ImageSource.gallery);
    if (image != null) {
      await image.saveTo('${globals.documentsPath}/$TEMP_IMAGE_FNAME');
      setState(() {
        _imageBytes = File('${globals.documentsPath}/$TEMP_IMAGE_FNAME')
            .readAsBytesSync();
      });
    }
  }

  Future<void> _getChallengePrompt() async {
    String prompt = await _promptHandler.generatePrompt(_isConnected);
    setState(() => _prompt = prompt);
  }

  void _wathAD() {
    globals.timerHandler.handleTimeout(SEND_TIMER);
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
          child: MyTimer(
              name: PROMPT_TIMER,
              forceShowChild: forceShowPage,
              children: (
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MyTimer(
                        name: SEND_TIMER,
                        forceShowChild: forceShowPic,
                        children: (
                          GestureDetector(
                              onTap: _chooseImage,
                              child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: ((_imageBytes != null)
                                          ? <Widget>[
                                              Image.memory(_imageBytes!,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      CHALLENGE_IMAGE_REL_HEIGHT,
                                                  fit: BoxFit.contain)
                                            ]
                                          : <Widget>[]) +
                                      [
                                        Icon(
                                          Icons.add_a_photo,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              PHOTO_ICON_REL_SIZE,
                                          color: Colors.black
                                              .withOpacity(PHOTO_ICON_OPACITY),
                                        ),
                                      ])),
                          Center(
                              child: LockLoseWidget(
                            secondsLeft: secondsLeftPic,
                            guessedWord: _guessedWord,
                            prompt: _prompt,
                            button: _isConnected
                                ? TextButton(
                                    onPressed: _wathAD,
                                    child: const Text('Watch AD to skip'))
                                : const SizedBox.shrink(),
                          ))
                        )),
                    Column(
                      children: [
                        const Text('Take a photo:'),
                        Text(_prompt),
                      ],
                    ),
                    TextButton(
                        onPressed: _submitChallenge, child: const Text('Send'))
                  ],
                ),
                Center(child: LockWinWidget(secondsLeft: secondsLeftPage))
              )),
        ));
  }
}
