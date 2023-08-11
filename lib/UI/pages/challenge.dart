import 'package:flutter/material.dart';
import 'package:just_snap/data/classifier_handler.dart';
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
  final ImagePicker _picker = ImagePicker();
  // ignore: unused_field
  late final ClassifierHandler _classifierHandler;

  _ChallengePageState(classifierHandler) {
    _classifierHandler = classifierHandler;
  }

  void _submitChallenge() {}
  Future<void> _chooseImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await image.saveTo('${globals.documentsPath}/possible_image.jpg');
    }
  }

  String _challengePrompt() {
    return _promptHandler.generatePrompt();
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
                    // Image.file(File('assets/images/1.jpg')),
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
                  onPressed: () => _submitChallenge(),
                  child: const Text('Send'))
            ],
          ),
        ));
  }
}
