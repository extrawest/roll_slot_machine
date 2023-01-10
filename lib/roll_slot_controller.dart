import 'dart:async';

import 'package:flutter/cupertino.dart';

enum RollSlotControllerState { none, animateRandomly, stopped }

class RollSlotController extends ChangeNotifier {
  RollSlotControllerState _state = RollSlotControllerState.none;

  RollSlotControllerState get state => _state;

  int _currentIndex = 0;

  int _index = 0;

  int get index => _index;

  final int? secondsBeforeStop;

  late Timer _stopAutomaticallyTimer;

  RollSlotController({
    this.secondsBeforeStop,
  });

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  int get currentIndex => _currentIndex;

  void animateRandomly({required int index}) {
    if (_state.isAnimateRandomly) {
      return;
    }
    _index = index;
    _state = RollSlotControllerState.animateRandomly;
    if (secondsBeforeStop != null) {
      _setAutomaticallyStopTimer(secondsBeforeStop!);
    }
    notifyListeners();
  }

  void stop() {
    if (_state.isAnimateRandomly) {
      _state = RollSlotControllerState.stopped;
      notifyListeners();
    }
  }

  void _setAutomaticallyStopTimer(int stopDuration) {
    _stopAutomaticallyTimer = Timer.periodic(const Duration(seconds: 1), (count) {
      if (count.tick == secondsBeforeStop) {
        if (!_state.isStopped) {
          stop();
        }
        _stopAutomaticallyTimer.cancel();
      }
    });
  }
}

extension RollSlotControllerStateExt on RollSlotControllerState {
  bool get isNone => this == RollSlotControllerState.none;
  bool get isAnimateRandomly => this == RollSlotControllerState.animateRandomly;
  bool get isStopped => this == RollSlotControllerState.stopped;
}
