import 'package:flutter/material.dart';
import '../../config.dart';
import '../../data/prompt_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final PromptHandler _promptHandler = PromptHandler();
  final ImagePicker _picker = ImagePicker();
  
  void _submitChallenge() {}
  Future<void> _chooseImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    final documentDirectory = await getApplicationDocumentsDirectory();
    if (image != null) {
      await image.saveTo('${documentDirectory.path}/just_snap/possible_image.jpg');
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
                  onPressed: () => _submitChallenge(), child: const Text('Send'))
            ],
          ),
        ));
  }
}
