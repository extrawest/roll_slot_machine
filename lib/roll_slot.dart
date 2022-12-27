import 'dart:async';
import 'dart:math';

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

  final bool additionalListToEndAndStart;

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
    this.additionalListToEndAndStart = true,
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
    addListenerScrollController();
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
          animateToRandomly();
        }
        if (widget.rollSlotController!.state == RollSlotControllerState.stopped) {
          stopRollSlot();
        }
      });
    }
  }

  void addListenerScrollController() {
    _controller.addListener(() {
      final currentScrollPixels = _controller.position.pixels;
      if (currentScrollPixels % widget.itemExtend == 0) {
        currentIndex = currentScrollPixels ~/ widget.itemExtend;
        final Widget currentWidget = currentList.elementAt(currentIndex);
        print('index : $currentIndex');
        if (widget.onItemSelected != null) {
          widget.onItemSelected!(
            currentIndex: currentIndex,
            currentWidget: currentWidget,
          );
        }
      }
    });
  }

  void shuffleAndFillTheList() {
    if (widget.children.isNotEmpty) {
      double d = (widget.duration.inMilliseconds / 100);
      if (widget.additionalListToEndAndStart) {
        addToCurrentList();
      }
      while (currentList.length < d) {
        addToCurrentList();
      }
      if (widget.additionalListToEndAndStart) {
        addToCurrentList();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          jump();
        });
      }
    }
  }

  /// Gets the [randomIndex] an animate the [RollSlot] to that item
  Future<void> animateToRandomly({double? index}) async {
    if (widget.rollSlotController != null) {
      int counter = 0;
      _timer = Timer.periodic(const Duration(milliseconds: 120), (timer) async {
        if (_isStopped) {
          await _controller.animateToItem(
            counter + 10,
            curve: Curves.easeOut,
            duration: const Duration(seconds: 2),
          );
          _timer.cancel();
          _isStopped = false;
        } else {
          await _controller.animateToItem(
            counter,
            curve: Curves.linear,
            duration: const Duration(milliseconds: 120),
          );
          counter++;
          if (counter == 80) {
            counter = 0;
          }
        }
      });
      // await _controller.animateTo(
      //   widget.rollSlotController!.index.toDouble() * widget.itemExtend,
      //   curve: Curves.elasticInOut,
      //   duration: widget.duration * (1 / widget.speed),
      // );
      //widget.rollSlotController!.currentIndex = widget.rollSlotController!.index % widget.children.length;
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

  /// Returns a random number.
  int randomIndex() {
    int randomInt;
    if (widget.additionalListToEndAndStart)
      randomInt = widget.children.length + Random().nextInt(currentList.length - widget.children.length);
    else
      randomInt = Random().nextInt(currentList.length);
    return randomInt == currentIndex ? randomIndex() : randomInt;
  }
}
