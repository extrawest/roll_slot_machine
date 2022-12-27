import 'package:flutter/cupertino.dart';

enum RollSlotControllerState { none, animateRandomly, stopped }

class RollSlotController extends ChangeNotifier {
  RollSlotControllerState _state = RollSlotControllerState.none;

  RollSlotControllerState get state => _state;

  int _currentIndex = 0;

  int _index = 0;

  int get index => _index;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  int get currentIndex => _currentIndex;

  void animateRandomly({required int index}) {
    if (_state == RollSlotControllerState.animateRandomly) {
      return;
    }
    _index = index;
    _state = RollSlotControllerState.animateRandomly;
    notifyListeners();
  }

  void stop() {
    _state = RollSlotControllerState.stopped;
    notifyListeners();
  }
}
