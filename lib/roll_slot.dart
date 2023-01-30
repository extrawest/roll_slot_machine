import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:roll_slot_machine/roll_slot_controller.dart';

typedef SelectedItemCallback = void Function({
  @required int currentIndex,
  @required Widget currentWidget,
});

class RollSlot extends StatefulWidget {
  final RollSlotController? rollSlotController;

  final List<Widget> children;
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
    this.curve = Curves.elasticOut,
    this.speed = 1.6,
    this.diameterRation = 1,
    this.perspective = 0.003,
    this.squeeze = 1.225,
    this.onItemSelected,
    this.shuffleList = true,
    this.itemPadding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  _RollSlotState createState() => _RollSlotState();
}

class _RollSlotState extends State<RollSlot> {
  final ScrollController _controller = ScrollController();
  final InfiniteScrollController _infiniteScrollController = InfiniteScrollController();

  List<Widget> currentList = [];
  int currentIndex = 0;
  bool _isStopped = false;

  late Timer _nextItemTimer;

  final List<GlobalKey> _globalKeys = [];

  @override
  void initState() {
    shuffleAndFillTheList();
    addRollSlotControllerListener();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
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
          return Container(
            child: widget.children[index % widget.children.length],
          );
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

  void shuffleAndFillTheList() {
    if (widget.children.isNotEmpty) {
      addToCurrentList();
    }
  }

  Future<void> animate() async {
    if (widget.rollSlotController != null) {
      _nextItemTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) async {
        stopSlotAtIndex(
          currentRollIndex: currentIndex % widget.children.length,
          prizeIndex: widget.rollSlotController!.index,
        );
      });
    }
  }

  void stopSlotAtIndex({required int currentRollIndex, required int prizeIndex}) {
    if (_isStopped && prizeIndex >= currentRollIndex) {
      final indexScrollTo = prizeIndex + (currentIndex - currentRollIndex);
      // if (_globalKeys[indexScrollTo].currentContext != null) {
      //   _controller.position.ensureVisible(
      //     _globalKeys[indexScrollTo].currentContext!.findRenderObject()!,
      //     duration: Duration(milliseconds: (prizeIndex - currentRollIndex + 10) * 120),
      //   );
      // }
      _infiniteScrollController.animateToItem(
        prizeIndex + (currentIndex - currentRollIndex),
        curve: Curves.easeOut,
        duration: Duration(milliseconds: (prizeIndex - currentRollIndex + 10) * 120),
      );
      _nextItemTimer.cancel();
      _isStopped = false;
    } else {
      // _controller.position.ensureVisible(
      //   _globalKeys[currentIndex].currentContext!.findRenderObject()!,
      //   duration: const Duration(milliseconds: 120),
      // );
      _infiniteScrollController.animateToItem(
        currentIndex,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 120),
      );
    }
    if (currentIndex >= widget.children.length) {
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
