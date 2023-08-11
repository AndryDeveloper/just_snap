import 'dart:io';
import 'package:pytorch_lite/pytorch_lite.dart';
import '../config.dart';

class ClassifierHandler {
  late final ClassificationModel? _classificationModel;

  Future load() async {
    return await Future(() => null);
    // _classificationModel = await PytorchLite.loadClassificationModel(
    //     CLASSIFIER_PATH, IMAGE_SIZE, IMAGE_SIZE, CLASSIFIER_NUM_CLASSES,
    //     labelPath: LABEL_PATH);
  }

  void unload() {
    _classificationModel = null;
  }

  Future<String> predict(String imagePath) async {
    if (_classificationModel == null) await load();
    return await _classificationModel!.getImagePrediction(
        await File(imagePath).readAsBytes(),
        mean: CLASSIFIER_MEAN,
        std: CLASSIFIER_STD);
  }
}
