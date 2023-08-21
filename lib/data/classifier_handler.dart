import 'dart:io';
import 'package:flutter_pytorch/flutter_pytorch.dart';
import '../config.dart';

class ClassifierHandler {
  late ClassificationModel? _classificationModel;

  Future load() async {
    if (!Platform.isWindows) {
      _classificationModel = await FlutterPytorch.loadClassificationModel(
          CLASSIFIER_PATH, IMAGE_SIZE, IMAGE_SIZE,
          labelPath: LABELS_PATH);
    }
  }

  void unload() {
    _classificationModel = null;
  }

  Future<List<String>> predict(String imagePath) async {
    if (!Platform.isWindows) {
      if (_classificationModel == null) await load();

      List<double?>? predictionListProbabilites = await _classificationModel!
          .getImagePredictionListProbabilities(
              File(imagePath).readAsBytesSync(),
              mean: CLASSIFIER_MEAN,
              std: CLASSIFIER_STD);

      List<String> topPredictions = List.filled(TOP_K_PREDICTIONS, 'None');
      for (int j = 0; j < TOP_K_PREDICTIONS; j++) {
        double maxScore = double.negativeInfinity;
        int maxScoreIndex = -1;
        for (int i = 0; i < predictionListProbabilites!.length; i++) {
          if (predictionListProbabilites[i]! > maxScore) {
            maxScore = predictionListProbabilites[i]!;
            maxScoreIndex = i;
          }
          topPredictions[j] = _classificationModel!.labels[maxScoreIndex];
          predictionListProbabilites[maxScoreIndex] = 0;
        }
      }
      return topPredictions;
    } else {
      return Future(() => List.filled(TOP_K_PREDICTIONS, 'patas'));
    }
  }
}
