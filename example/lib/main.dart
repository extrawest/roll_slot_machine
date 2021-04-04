import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roll_slot_machine/roll_slot_machine.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roll Slot Machine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: 'home',
      onGenerateRoute: onGenerateRoute,
    );
  }

  Route onGenerateRoute(RouteSettings settings) {
    if (settings.name == 'home') {
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return MyHomePage(
            title: 'title',
          );
        },
      );
    }
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> values = List.generate(100, (index) => index);

  var _rollSlotController = RollSlotController();
  var _rollSlotController1 = RollSlotController();
  var _rollSlotController2 = RollSlotController();
  var _rollSlotController3 = RollSlotController();
  final random = Random();
  final List<String> emojiList = [
    '😀',
    '😃',
    '😄',
    '😁',
    '😆',
    '😅',
    '🤣',
    '😂',
    '🙂',
    '🙃',
    '😉',
    '😊',
    '😇',
    '🥰',
    '😍',
    '🤩',
    '😘',
    '😗',
    '☺',
    '😚',
    '😙',
    '🥲',
    '😋',
    '😛',
    '😜',
    '🤪',
    '😝',
    '🤑',
    '🤗',
    '🤭',
    '🤫',
    '🤔',
    '🤐',
    '🤨',
    '😐',
    '😑',
    '😶',
    '😏',
    '😒',
    '🙄',
    '😬',
    '🤥',
    '😌',
    '😔',
    '😪',
    '🤤',
    '😴',
    '😷',
    '🤒',
    '🤕',
    '🤢',
    '🤮',
    '🤧',
    '🥵',
    '🥶',
    '🥴',
    '😵',
    '🤯',
    '🤠',
    '🥳',
    '🥸',
    '😎',
    '🤓',
    '🧐',
    '😕',
    '😟',
    '🙁',
    '☹',
    '😮',
    '😯',
    '😲',
    '😳',
    '🥺',
    '😦',
    '😧',
    '😨',
    '😰',
    '😥',
    '😢',
    '😭',
    '😱',
    '😖',
    '😣',
    '😞',
    '😓',
    '😩',
    '😫',
    '🥱',
    '😤',
    '😡',
    '😠',
    '🤬',
    '😈',
    '👿',
    '💀',
    '☠',
    '💩',
    '🤡',
    '👹',
    '👺',
    '👻',
    '👽',
    '👾',
    '🤖',
    '😺',
    '😸',
    '😹',
    '😻',
    '😼',
    '😽',
    '🙀',
    '😿',
    '😾',
    '💋',
    '👋',
    '🤚',
    '🖐',
    '✋',
    '🖖',
    '👌',
    '🤌',
    '🤏',
    '✌',
    '🤞',
    '🤟',
    '🤘',
    '🤙',
    '👈',
    '👉',
    '👆',
    '🖕',
    '👇',
    '☝',
    '👍',
    '👎',
    '✊',
    '👊',
    '🤛',
    '🤜',
    '👏',
    '🙌',
    '👐',
    '🤲',
    '🤝',
    '🙏',
    '✍',
    '💅',
    '🤳',
    '💪',
    '🦾',
    '🦿',
    '🦵',
    '🦶',
    '👂',
    '🦻',
    '👃',
    '🧠',
    '🫀',
    '🫁',
    '🦷',
    '🦴',
    '👀',
    '👁',
    '👅',
    '👄',
    '👶',
    '🧒',
    '👦',
    '👧',
    '🧑',
    '👱',
    '👨',
    '🧔',
    '👨',
    '👨',
    '👨',
    '👨',
    '👩',
    '👩',
    '🧑',
    '👩',
    '🧑',
    '👩',
    '🧑',
    '👩',
    '🧑',
    '👱',
    '👱',
    '🧓',
    '👴',
    '👵',
    '🙍',
    '🙍',
    '🙍',
    '🙎',
    '🙎',
    '🙎',
    '🙅',
    '🙅',
    '🙅',
    '🙆',
    '🙆',
    '🙆',
    '💁',
    '💁',
    '💁',
    '🙋',
    '🙋',
    '🙋',
    '🧏',
    '🧏',
    '🧏',
    '🙇',
    '🙇',
    '🙇',
    '🤦',
    '🤦',
    '🤦',
    '🤷',
    '🤷',
    '🤷',
    '🧑',
    '👨',
    '👩',
    '🧑',
    '👨',
    '👩',
    '🧑',
    '👨',
    '👩',
    '🧑',
    '👨',
    '👩',
    '🧑',
    '👨',
    '👩',
    '🧑',
    '👨',
    '👩',
    '🧑',
    '👨',
    '👩',
    '🧑',
    '👨',
    '👩',
    '🧑',
    '👨',
    '👩',
    '🧑',
    '👨',
    '👩',
    '🧑',
    '👨',
    '👩',
    '🧑',
    '👨',
    '👩',
    '🧑',
    '👨',
    '👩',
    '🧑',
    '👨',
    '👩',
    '🧑',
    '👨',
    '👩',
    '🧑',
    '👨',
    '👩',
    '👮',
    '👮',
    '👮',
    '🕵',
    '🕵',
    '🕵',
    '💂',
    '💂',
    '💂',
    '🥷',
    '👷',
    '👷',
    '👷',
    '🤴',
    '👸',
    '👳',
    '👳',
    '👳',
    '👲',
    '🧕',
    '🤵',
    '🤵',
    '🤵',
    '👰',
    '👰',
    '👰',
    '🤰',
    '🤱',
    '👩',
    '👨',
    '🧑',
    '👼',
    '🎅',
    '🤶',
    '🧑',
    '🦸',
    '🦸',
    '🦸',
    '🦹',
    '🦹',
    '🦹',
    '🧙',
    '🧙',
    '🧙',
    '🧚',
    '🧚',
    '🧚',
    '🧛',
    '🧛',
    '🧛',
    '🧜',
    '🧜',
    '🧜',
    '🧝',
    '🧝',
    '🧝',
    '🧞',
    '🧞',
    '🧞',
    '🧟',
    '🧟',
    '🧟',
    '💆',
    '💆',
    '💆',
    '💇',
    '💇',
    '💇',
    '🚶',
    '🚶',
    '🚶',
    '🧍',
    '🧍',
    '🧍',
    '🧎',
    '🧎',
    '🧎',
    '🧑',
    '👨',
    '👩',
    '🧑',
    '👨',
    '👩',
    '🧑',
    '👨',
    '👩',
    '🏃',
    '🏃',
    '🏃',
    '💃',
    '🕺',
    '🕴',
    '👯',
    '👯',
    '👯',
    '🧖',
    '🧖',
    '🧖',
    '🧘',
    '🧑',
    '👭',
    '👫',
    '👬',
    '💏',
    '👩',
    '👨',
    '👩',
    '💑',
    '👩',
    '👨',
    '👩',
    '👪',
    '👨',
    '👨',
    '👨',
    '👨',
    '👨',
    '👨',
    '👨',
    '👨',
    '👨',
    '👨',
    '👩',
    '👩',
    '👩',
    '👩',
    '👩',
    '👨',
    '👨',
    '👨',
    '👨',
    '👨',
    '👩',
    '👩',
    '👩',
    '👩',
    '👩',
    '🗣',
    '👤',
    '👥',
    '🫂',
    '👣',
    '🧳',
    '🌂',
    '☂',
    '🎃',
    '🧵',
    '🧶',
    '👓',
    '🕶',
    '🥽',
    '🥼',
    '🦺',
    '👔',
    '👕',
    '👖',
    '🧣',
    '🧤',
    '🧥',
    '🧦',
    '👗',
    '👘',
    '🥻',
    '🩱',
    '🩲',
    '🩳',
    '👙',
    '👚',
    '👛',
    '👜',
    '👝',
    '🎒',
    '🩴',
    '👞',
    '👟',
    '🥾',
    '🥿',
    '👠',
    '👡',
    '🩰',
    '👢',
    '👑',
    '👒',
    '🎩',
    '🎓',
    '🧢',
    '🪖',
    '⛑',
    '💄',
    '💍',
    '💼',
    '🩸',
    '😮',
    '😵',
    '😶',
  ];

  @override
  void initState() {
    _rollSlotController.addListener(() {
      // trigger setState method to reload ui with new index
      // in our case the AppBar title will change
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(getText()),
      ),
      body: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Row(
                  children: [
                    RollSlotWidget(
                      emojiList: emojiList,
                      rollSlotController: _rollSlotController,
                    ),
                    if (size.width > 500)
                      RollSlotWidget(
                        emojiList: emojiList,
                        rollSlotController: _rollSlotController1,
                      ),
                    if (size.width > 800)
                      RollSlotWidget(
                        emojiList: emojiList,
                        rollSlotController: _rollSlotController2,
                      ),
                    if (size.width > 1000)
                      RollSlotWidget(
                        emojiList: emojiList,
                        rollSlotController: _rollSlotController3,
                      ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    height: 600,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xff2f5d62), width: 50)),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _rollSlotController.animateRandomly();
          if (size.width > 500) _rollSlotController1.animateRandomly();
          if (size.width > 800) _rollSlotController2.animateRandomly();
          if (size.width > 800) _rollSlotController3.animateRandomly();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  String getText() {
    final String x = emojiList.elementAt(_rollSlotController.currentIndex) +
        emojiList.elementAt(_rollSlotController1.currentIndex) +
        emojiList.elementAt(_rollSlotController2.currentIndex) +
        emojiList.elementAt(_rollSlotController3.currentIndex);
    return x;
  }
}

class RollSlotWidget extends StatelessWidget {
  final List<String> emojiList;

  final RollSlotController rollSlotController;

  const RollSlotWidget({Key key, this.emojiList, this.rollSlotController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RollSlot(
                  duration: Duration(milliseconds: 6000),
                  itemExtend: 300,
                  shuffleList: false,
                  rollSlotController: rollSlotController,
                  children: emojiList.map(
                    (e) {
                      return BuildItem(
                        emoji: e,
                      );
                    },
                  ).toList()),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildItem extends StatelessWidget {
  const BuildItem({
    Key key,
    this.index,
    this.emoji,
  }) : super(key: key);

  final int index;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
              color: Color(0xff2f5d62).withOpacity(.2), offset: Offset(5, 5)),
          BoxShadow(
              color: Color(0xff2f5d62).withOpacity(.2), offset: Offset(-5, -5)),
        ],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xff2f5d62),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        emoji,
        key: Key(emoji),
        style: const TextStyle(fontSize: 100),
      ),
    );
  }
}
