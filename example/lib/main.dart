import 'dart:math';

import 'package:example/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roll_slot_machine/roll_slot.dart';
import 'package:roll_slot_machine/roll_slot_controller.dart';

class Assets {
  static const seventhIc = 'assets/images/777.svg';
  static const cherryIc = 'assets/images/cherry.svg';
  static const appleIc = 'assets/images/apple.svg';
  static const barIc = 'assets/images/bar.svg';
  static const coinIc = 'assets/images/coin.svg';
  static const crownIc = 'assets/images/crown.svg';
  static const lemonIc = 'assets/images/lemon.svg';
  static const watermelonIc = 'assets/images/watermelon.svg';
}

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

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == 'home') {
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return MyHomePage(
            title: 'title',
          );
        },
      );
    }
    return null;
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> values = List.generate(100, (index) => index);

  final _rollSlotController = RollSlotController(secondsBeforeStop: 10);
  final _rollSlotController1 = RollSlotController(secondsBeforeStop: 10);
  final _rollSlotController2 = RollSlotController(secondsBeforeStop: 10);
  final _rollSlotController3 = RollSlotController(secondsBeforeStop: 10);
  final random = Random();
  final List<String> prizesList = [
    Assets.seventhIc,
    Assets.cherryIc,
    Assets.appleIc,
    Assets.barIc,
    Assets.coinIc,
    Assets.crownIc,
    Assets.lemonIc,
    Assets.watermelonIc,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Roll slot machine'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              RollSlotWidget(
                prizesList: prizesList,
                rollSlotController: _rollSlotController,
              ),
              RollSlotWidget(
                prizesList: prizesList,
                rollSlotController: _rollSlotController1,
              ),
              RollSlotWidget(
                prizesList: prizesList,
                rollSlotController: _rollSlotController2,
              ),
              RollSlotWidget(
                prizesList: prizesList,
                rollSlotController: _rollSlotController3,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final index = prizesList.length - 1;
          _rollSlotController.animateRandomly(
              topIndex: Random().nextInt(index),
              centerIndex: Random().nextInt(index),
              bottomIndex: Random().nextInt(index));
          _rollSlotController1.animateRandomly(
              topIndex: Random().nextInt(index),
              centerIndex: Random().nextInt(index),
              bottomIndex: Random().nextInt(index));
          _rollSlotController2.animateRandomly(
              topIndex: Random().nextInt(index),
              centerIndex: Random().nextInt(index),
              bottomIndex: Random().nextInt(index));
          _rollSlotController3.animateRandomly(
              topIndex: Random().nextInt(index),
              centerIndex: Random().nextInt(index),
              bottomIndex: Random().nextInt(index));
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class RollSlotWidget extends StatelessWidget {
  final List<String> prizesList;

  final RollSlotController rollSlotController;

  const RollSlotWidget({Key? key, required this.prizesList, required this.rollSlotController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: RollSlot(
                itemExtend: 115,
                rollSlotController: rollSlotController,
                children: prizesList.map(
                  (e) {
                    return BuildItem(
                      asset: e,
                    );
                  },
                ).toList()),
          ),
          Flexible(
            child: TextButton(
              onPressed: () => rollSlotController.stop(),
              child: Text('Stop'),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildItem extends StatelessWidget {
  const BuildItem({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(color: darkBlue1.withOpacity(.2), offset: Offset(5, 5)),
          BoxShadow(color: darkBlue1.withOpacity(.2), offset: Offset(-5, -5)),
        ],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: darkBlue1,
        ),
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        asset,
        key: Key(asset),
      ),
    );
  }
}
