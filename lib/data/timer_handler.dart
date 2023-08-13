import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:just_snap/config.dart';
import '../globals.dart' as globals;

class TimerHandler {
  late final File _timerFile;
  final Map<String, int> _timersExpDateTime = {};
  final Map<String, Map<int, Function(int)>> _timersCallbacks = {};

  TimerHandler() {
    _timerFile = File('${globals.documentsPath}/$TIMER_HISTORY_FNAME');
    if (!_timerFile.existsSync()) _timerFile.createSync();
    if (_timerFile.lengthSync() != 0) {
      Map<String, dynamic> data = json.decode(_timerFile.readAsStringSync());
      for (final element in data.entries) {
        _timersExpDateTime[element.key] = element.value as int;
      }
      if (_timersExpDateTime.isNotEmpty) {
        for (final element in _timersExpDateTime.entries) {
          Duration duration = DateTime.fromMillisecondsSinceEpoch(element.value)
              .difference(DateTime.now().toUtc());
          if (duration.inSeconds > 0) {
            Timer timerPeriodic = Timer.periodic(
                const Duration(seconds: TIMER_CALLBACK_EVERY),
                (Timer t) => handleTimerTick(element.key));
            Timer(duration, () => handleTimeout(element.key, timerPeriodic));
          } else {
            _timersExpDateTime[element.key] = -1;
          }
        }
        _timersExpDateTime
            .removeWhere((String key, dynamic value) => value == -1);
      }
      _timerFile.writeAsStringSync(json.encode(_timersExpDateTime));
    }
  }

  bool checkTimer(String name) {
    return _timersExpDateTime.containsKey(name);
  }

  Duration timerDuration(String name) {
    if (checkTimer(name)) {
      return DateTime.fromMillisecondsSinceEpoch(_timersExpDateTime[name]!)
          .difference(DateTime.now().toUtc());
    } else {
      return const Duration(seconds: 0);
    }
  }

  void createTimer(String name, Duration duration) {
    _timersExpDateTime[name] =
        DateTime.now().toUtc().add(duration).millisecondsSinceEpoch;
    Timer timerPeriodic = Timer.periodic(
        const Duration(seconds: TIMER_CALLBACK_EVERY),
        (Timer t) => handleTimerTick(name));
    Timer(duration, () => handleTimeout(name, timerPeriodic));
    _timerFile.writeAsStringSync(json.encode(_timersExpDateTime));
    handleTimerTick(name);
  }

  void addCallback(String name, Function(int) callback, int id) {
    if (!_timersCallbacks.containsKey(name)) _timersCallbacks[name] = {};
    _timersCallbacks[name]![id] = callback;
    if (_timersExpDateTime.containsKey(name)) {
      handleTimerTick(name);
    }
  }

  void removeCallback(String name, int id) {
    if (_timersCallbacks.containsKey(name)) {
      if (_timersCallbacks[name]!.containsKey(id)) {
        _timersCallbacks[name]!.remove(id);
      }
    }
  }

  void handleTimerTick(String name) {
    if (_timersCallbacks.containsKey(name)) {
      for (Function(int) callback in _timersCallbacks[name]!.values) {
        int difference =
            DateTime.fromMillisecondsSinceEpoch(_timersExpDateTime[name]!)
                .difference(DateTime.now().toUtc())
                .inSeconds;
        callback((difference >= 0) ? difference : 0);
      }
    }
  }

  void handleTimeout(String name, Timer timerPeriodic) {
    timerPeriodic.cancel();
    if (_timersCallbacks.containsKey(name)) {
      for (Function(int) callback in _timersCallbacks[name]!.values) {
        callback(0);
      }
    }
    // _timersCallbacks.remove(name);
    _timersExpDateTime.remove(name);
  }
}
