import 'dart:io';
import 'package:flutter_pytorch/flutter_pytorch.dart';
import '../config.dart';

class ClassifierHandler {
  late ClassificationModel? _classificationModel;

  Future load() async {
    _classificationModel = await FlutterPytorch.loadClassificationModel(
        CLASSIFIER_PATH, IMAGE_SIZE, IMAGE_SIZE,
        labelPath: LABELS_PATH);
  }

  void unload() {
    _classificationModel = null;
  }

  Future<String> predict(String imagePath) async {
    if (_classificationModel == null) await load();
    return await _classificationModel!.getImagePrediction(
        File(imagePath).readAsBytesSync(),
        mean: CLASSIFIER_MEAN,
        std: CLASSIFIER_STD);
  }
}
