import 'dart:async';

import 'package:flutter/material.dart';
import 'package:roll_slot_machine/roll_slot_controller.dart';

typedef void SelectedItemCallback({
  @required int currentIndex,
  @required Widget currentWidget,
});

class RollSlot extends StatefulWidget {
  final RollSlotController? rollSlotController;

  final List<Widget> children;
  final Duration duration;
  final Curve curve;
  final double speed;

  final double diameterRation;

  final double itemExtend;

  final double perspective;

  final double squeeze;

  final SelectedItemCallback? onItemSelected;

  final bool shuffleList;

  final EdgeInsets itemPadding;

  const RollSlot({
    Key? key,
    required this.itemExtend,
    required this.children,
    this.rollSlotController,
    this.duration = const Duration(milliseconds: 3600),
    this.curve = Curves.elasticOut,
    this.speed = 1.6,
    this.diameterRation = 1,
    this.perspective = 0.002,
    this.squeeze = 1.4,
    this.onItemSelected,
    this.shuffleList = true,
    this.itemPadding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  _RollSlotState createState() => _RollSlotState();
}

class _RollSlotState extends State<RollSlot> {
  final FixedExtentScrollController _controller = FixedExtentScrollController(initialItem: 0);
  List<Widget> currentList = [];
  int currentIndex = 0;
  late Timer _timer;
  bool _isStopped = false;

  @override
  void initState() {
    shuffleAndFillTheList();
    addRollSlotControllerListener();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      //onSelectedItemChanged: (index) => currentIndex = index,
      physics: BouncingScrollPhysics(),
      itemExtent: widget.itemExtend,
      diameterRatio: widget.diameterRation,
      controller: _controller,
      squeeze: widget.squeeze,
      perspective: widget.perspective,
      childDelegate: ListWheelChildLoopingListDelegate(
        children: currentList.map((_widget) {
          return Padding(
            padding: widget.itemPadding,
            child: _widget,
          );
        }).toList(),
      ),
    );
  }

  void addRollSlotControllerListener() {
    if (widget.rollSlotController != null) {
      widget.rollSlotController!.addListener(() {
        if (widget.rollSlotController!.state == RollSlotControllerState.animateRandomly) {
          animate();
        }
        if (widget.rollSlotController!.state == RollSlotControllerState.stopped) {
          stopRollSlot();
        }
      });
    }
  }

  void shuffleAndFillTheList() {
    if (widget.children.isNotEmpty) {
      addToCurrentList();
    }
  }

  Future<void> animate() async {
    if (widget.rollSlotController != null) {
      _timer = Timer.periodic(const Duration(milliseconds: 120), (timer) async {
        int currentRollIndex = currentIndex % widget.children.length;
        int prizeIndex = widget.rollSlotController!.index;
        if (_isStopped && prizeIndex > currentRollIndex) {
          _controller.animateToItem(
            prizeIndex + (currentIndex - currentRollIndex),
            curve: Curves.easeOut,
            duration: Duration(milliseconds: (prizeIndex - currentRollIndex + 10) * 120),
          );
          _timer.cancel();
          _isStopped = false;
        } else {
          _controller.animateToItem(
            currentIndex,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 120),
          );
        }
        currentIndex++;
      });
    }
  }

  void stopRollSlot() {
    if (widget.rollSlotController != null) {
      _isStopped = true;
    }
  }

  /// When [additionalListToEndAndStart] is true,
  /// This method adds the [widget.children] to beginning and end of the list
  ///
  /// for being able to show items if the random number hits edge cases
  void addToCurrentList() {
    setState(() {
      if (widget.shuffleList) {
        currentList.addAll(widget.children.toList()..shuffle());
      } else {
        currentList.addAll(widget.children.toList());
      }
    });
  }

  /// Helping to jump the first item that can be random.
  ///
  /// It is using only when the [additionalListToEndAndStart] is true.
  void jump() {
    _controller.jumpTo(widget.itemExtend * widget.children.length);
  }
}
