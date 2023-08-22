import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:just_snap/UI/lock_screens.dart';
import 'package:just_snap/data/classifier_handler.dart';
import 'package:just_snap/data/history_handler.dart';
import 'package:just_snap/data/language_handler.dart';
import '../../config.dart';
import '../../data/prompt_handler.dart';
import 'package:image_picker/image_picker.dart';
import '../../globals.dart' as globals;
import 'package:just_snap/UI/timer.dart';

class ChallengePage extends StatefulWidget {
  final LanduageHandler languageHandler;
  const ChallengePage({super.key, required this.languageHandler});

  @override
  // ignore: no_logic_in_create_state
  State<ChallengePage> createState() => _ChallengePageState(languageHandler);
}

class _ChallengePageState extends State<ChallengePage> {
  final PromptHandler _promptHandler = PromptHandler();
  final HistoryHandler _historyHandler = HistoryHandler();
  late final LanduageHandler _languageHandler;
  final ClassifierHandler _classifierHandler = ClassifierHandler();
  final ImagePicker _picker = ImagePicker();
  String? _prompt;
  List<String>? _labels;
  Uint8List? _imageBytes;
  late bool forceShowPage;
  late int secondsLeftPage;
  late bool forceShowPic;
  late int secondsLeftPic;
  late StreamSubscription<InternetConnectionStatus> connectionListener;
  bool _isConnected = false;
  String? _guessedWord;

  _ChallengePageState(languageHandler) {
    _languageHandler = languageHandler;
    forceShowPage = !_historyHandler.guessedToday();
    secondsLeftPage =
        globals.timerHandler.timerDuration(PROMPT_TIMER).inSeconds;
    forceShowPic = false;
    secondsLeftPic = globals.timerHandler.timerDuration(SEND_TIMER).inSeconds;
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
        !globals.timerHandler.checkTimer(SEND_TIMER) &&
        _classifierHandler.modelLoaded) {
      List<String> prediction = await _classifierHandler
          .predict('${globals.documentsPath}/$TEMP_IMAGE_FNAME');

      _guessedWord = prediction[0];
      if (prediction.contains(_prompt)) {
        _historyHandler.addEntry(_prompt!);
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
    _labels =
        (await rootBundle.loadString(_languageHandler.labelsPath)).split('\n');
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
          title: Text(_languageHandler.loadPictureText),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  _languageHandler.language =
                      _languageHandler.language == 'ru' ? 'en' : 'ru';
                  await _getChallengePrompt();
                  setState(() {});
                },
                child: Text(_languageHandler.language))
          ],
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
                            landuageHandler: _languageHandler,
                            secondsLeft: secondsLeftPic,
                            guessedWord: _guessedWord == null
                                ? GUESSES_WORD_PLACEHOLDER
                                : _labels![int.parse(_guessedWord!)],
                            prompt: _prompt == null
                                ? PROMPT_PLACEHOLDER
                                : _labels![int.parse(_prompt!)],
                            button: _isConnected
                                ? TextButton(
                                    onPressed: _wathAD,
                                    child: Text(_languageHandler.wathADText))
                                : const SizedBox.shrink(),
                          ))
                        )),
                    Column(
                      children: [
                        Text(_languageHandler.takePictureText),
                        Text(_prompt == null
                            ? PROMPT_PLACEHOLDER
                            : _labels![int.parse(_prompt!)]),
                      ],
                    ),
                    TextButton(
                        onPressed: _submitChallenge,
                        child: Text(_languageHandler.sendText))
                  ],
                ),
                Center(
                    child: LockWinWidget(
                        landuageHandler: _languageHandler,
                        secondsLeft: secondsLeftPage))
              )),
        ));
  }
}
