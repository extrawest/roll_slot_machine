import 'package:flutter/cupertino.dart';

enum RollSlotControllerState { animateRandomly, stopped }

class RollSlotController extends ChangeNotifier {
  RollSlotControllerState _state = RollSlotControllerState.animateRandomly;

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
    _index = index;
    _state = RollSlotControllerState.animateRandomly;
    notifyListeners();
    _state = RollSlotControllerState.stopped;
  }
}
