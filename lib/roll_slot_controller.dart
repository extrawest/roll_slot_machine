import 'dart:async';

import 'package:flutter/cupertino.dart';

enum RollSlotControllerState { none, animateRandomly, stopped }

class RollSlotController extends ChangeNotifier {
  RollSlotControllerState _state = RollSlotControllerState.none;

  RollSlotControllerState get state => _state;

  int _topIndex = 0;
  int _centerIndex = 0;
  int _bottomIndex = 0;

  int get centerIndex => _centerIndex;
  int get bottomIndex => _bottomIndex;
  int get topIndex => _topIndex;

  final int? secondsBeforeStop;

  late Timer _stopAutomaticallyTimer;

  RollSlotController({
    this.secondsBeforeStop,
  });

  void animateRandomly({
    required int topIndex,
    required int centerIndex,
    required int bottomIndex,
  }) {
    if (_state.isAnimateRandomly) {
      return;
    }
    _topIndex = topIndex;
    _centerIndex = centerIndex;
    _bottomIndex = bottomIndex;

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
