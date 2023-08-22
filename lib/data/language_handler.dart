import 'dart:io';
import 'package:just_snap/config.dart';
import '../globals.dart' as globals;

class LanduageHandler {
  late File _historyFile;
  late String _language;

  LanduageHandler() {
    _historyFile = File('${globals.documentsPath}/$LANGUAGE_FNAME');
    if (!_historyFile.existsSync()) {
      _historyFile.createSync();
      _language = DEFAULT_LANGUAGE;
      _historyFile.writeAsStringSync(_language);
    } else {
      _language = _historyFile.readAsStringSync();
    }
  }

  String get takePictureText {
    if (_language == 'ru') {
      return 'Сделайте фотографию:';
    } else {
      return 'Take a photo:';
    }
  }

  String get sendText {
    if (_language == 'ru') {
      return 'Отправить';
    } else {
      return 'Send';
    }
  }

  String get wathADText {
    if (_language == 'ru') {
      return 'Посмотреть рекламу, чтобы пропустить';
    } else {
      return 'Watch AD to skip';
    }
  }

  String get loadPictureText {
    if (_language == 'ru') {
      return 'Загрузите фотографию';
    } else {
      return 'Load your picture';
    }
  }

  String get historyText {
    if (_language == 'ru') {
      return 'История';
    } else {
      return 'History';
    }
  }

  String winTimerText(dateFormat) {
    if (_language == 'ru') {
      return 'Вы уже сфотографировали нужный предмет,\nследующий появится через\n$dateFormat';
    } else {
      return 'You have already photographed the desired item,\nthe next one will appear in\n$dateFormat';
    }
  }

  String loseTimerText(guessedWord, prompt, dateFormat) {
    if (_language == 'ru') {
      return 'Извините, но мы думаем, что Вы сфотографировали $guessedWord,\nвместо $prompt,\nВы можете повторить попытку через\n$dateFormat';
    } else {
      return 'Sorry, but we think you took a photo of the $guessedWord,\ninstead of $prompt,\nyou can try again in\n$dateFormat';
    }
  }

  String get labelsPath =>
      '${LABELS_PATH.substring(0, LABELS_PATH.length - 4)}_$_language.txt';
  String get language => _language;
  set language(String language) {
    _language = language;
    _historyFile.writeAsStringSync(_language);
  }
}
