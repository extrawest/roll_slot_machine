import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:roll_slot_machine/roll_slot_controller.dart';

typedef SelectedItemCallback = void Function({
  @required int currentIndex,
  @required Widget currentWidget,
});

// after hitting this index it will reset to zero
const maxIndex = 50000;

class RollSlot extends StatefulWidget {
  final RollSlotController? rollSlotController;

  final List<Widget> children;
  final Curve curve;

  final double itemExtend;

  final EdgeInsets itemPadding;

  const RollSlot({
    Key? key,
    required this.itemExtend,
    required this.children,
    this.rollSlotController,
    this.curve = Curves.easeOut,
    this.itemPadding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  _RollSlotState createState() => _RollSlotState();
}

class _RollSlotState extends State<RollSlot> {
  final InfiniteScrollController _infiniteScrollController = InfiniteScrollController();

  int currentIndex = 0;
  int _stopIndex = 0;
  bool _isStopped = false;

  int topTemporaryIndex = 0;
  int centerTemporaryIndex = 0;
  int bottomTemporaryIndex = 0;

  late Timer _nextItemTimer;

  @override
  void initState() {
    addRollSlotControllerListener();
    super.initState();
  }

  @override
  void dispose() {
    _infiniteScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: false,
      child: InfiniteCarousel.builder(
        physics: BouncingScrollPhysics(),
        itemExtent: widget.itemExtend,
        controller: _infiniteScrollController,
        itemCount: widget.children.length,
        axisDirection: Axis.vertical,
        itemBuilder: (context, index, realIndex) {
          if (widget.rollSlotController!.state.isStopped) {
            /// we build "winning" items on the specific indexes(top, center, bottom)
            /// only when rollSlotController is stopped
            /// we don't need to build especially them when slot is rolling
            if (realIndex == _stopIndex) {
              centerTemporaryIndex = widget.rollSlotController!.centerIndex;
              return widget.children[centerTemporaryIndex];
            } else if (realIndex == _stopIndex - 1) {
              topTemporaryIndex = widget.rollSlotController!.topIndex;
              return widget.children[topTemporaryIndex];
            } else if (realIndex == _stopIndex + 1) {
              bottomTemporaryIndex = widget.rollSlotController!.bottomIndex;
              return widget.children[bottomTemporaryIndex];
            } else {
              final random = Random().nextInt(widget.children.length - 1);
              return Container(child: widget.children[random]);
            }
          } else {
            /// this logic is necessary to avoid rebuilding previous
            /// top, center and bottom items, when user start to roll slot again
            if (realIndex == _stopIndex) {
              return widget.children[centerTemporaryIndex];
            } else if (realIndex == _stopIndex - 1) {
              return widget.children[topTemporaryIndex];
            } else if (realIndex == _stopIndex + 1) {
              return widget.children[bottomTemporaryIndex];
            } else {
              final random = Random().nextInt(widget.children.length - 1);
              return Container(child: widget.children[random]);
            }
          }
        },
      ),
    );
  }

  void addRollSlotControllerListener() {
    if (widget.rollSlotController != null) {
      widget.rollSlotController!.addListener(() {
        if (widget.rollSlotController!.state.isAnimateRandomly) {
          animate();
        }
        if (widget.rollSlotController!.state.isStopped) {
          stopRollSlot();
        }
      });
    }
  }

  Future<void> animate() async {
    if (widget.rollSlotController != null) {
      _nextItemTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) async {
        stopSlotAtIndex(
          currentRollIndex: currentIndex % widget.children.length,
        );
      });
    }
  }

  void stopSlotAtIndex({required int currentRollIndex}) {
    if (_isStopped) {
      _stopIndex = currentIndex + 10;
      _infiniteScrollController.animateToItem(
        _stopIndex,
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 20 * 120),
      );
      _nextItemTimer.cancel();
      _isStopped = false;
      currentIndex = _stopIndex;
    } else {
      _infiniteScrollController.animateToItem(
        currentIndex,
        curve: widget.curve,
        duration: const Duration(milliseconds: 120),
      );
    }
    if (currentIndex >= maxIndex) {
      currentIndex = 0;
    } else {
      currentIndex++;
    }
  }

  void stopRollSlot() {
    if (widget.rollSlotController != null) {
      _isStopped = true;
    }
  }
}
