import 'dart:math';

import 'package:flutter/material.dart';

typedef void SelectedItemCallback({
  @required int currentIndex,
  @required Widget currentWidget,
});

class RollSlot extends StatefulWidget {
  final GlobalKey<RollSlotState> rollSlotController;

  final List<Widget> children;
  final Duration duration;
  final Curve curve;
  final double speed;

  final double diameterRation;

  final double itemExtend;

  final double perspective;

  final double squeeze;

  final SelectedItemCallback onItemSelected;

  final bool shuffleList;

  final bool additionalListToEndAndStart;

  const RollSlot({
    Key key,
    @required this.itemExtend,
    @required this.children,
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
  }) : super(key: rollSlotController);

  @override
  RollSlotState createState() => RollSlotState();
}

class RollSlotState extends State<RollSlot> {
  ScrollController _controller = ScrollController();
  List<Widget> currentList = [];
  int currentIndex = 0;

  @override
  void initState() {
    shuffleAndFillTheList();
    addListenerScrollController();
    super.initState();
  }

  void addListenerScrollController() {
    _controller.addListener(() {
      final currentScrollPixels = _controller.position.pixels;
      if (currentScrollPixels % widget.itemExtend == 0) {
        currentIndex = currentScrollPixels ~/ widget.itemExtend;
        final Widget currentWidget = currentList.elementAt(currentIndex);
        print('index : $currentIndex');
        if (widget.onItemSelected != null) {
          widget.onItemSelected(
            currentIndex: currentIndex,
            currentWidget: currentWidget,
          );
        }
      }
    });
  }

  void shuffleAndFillTheList() {
    if (widget.children != null && widget.children.isNotEmpty) {
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

  void addToCurrentList() {
    setState(() {
      if (widget.shuffleList) {
        currentList.addAll(widget.children.toList()..shuffle());
      } else {
        currentList.addAll(widget.children.toList());
      }
    });
  }

  void animateToRandomly() {
    _controller.animateTo(
      randomIndex() * widget.itemExtend,
      curve: Curves.elasticInOut,
      duration: widget.duration * (1 / widget.speed),
    );
  }

  void jump() {
    _controller.jumpTo(widget.itemExtend * widget.children.length);
  }

  int randomIndex() {
    int randomInt;
    if (widget.additionalListToEndAndStart)
      randomInt = widget.children.length +
          Random().nextInt(currentList.length - widget.children.length);
    else
      randomInt = Random().nextInt(currentList.length);
    return randomInt == currentIndex ? randomIndex() : randomInt;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView(
      physics: BouncingScrollPhysics(),
      itemExtent: widget.itemExtend,
      diameterRatio: widget.diameterRation,
      controller: _controller,
      squeeze: widget.squeeze,
      perspective: widget.perspective,
      children: currentList.map((widget) {
        return widget;
      }).toList(),
      onSelectedItemChanged: (selectedIndex) {
        print('herre');
        print('selected inddex : $selectedIndex');
      },
    );
  }
}
