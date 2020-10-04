import 'package:example/cards_page.dart';
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
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CardsPage(),
    );
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
        title: Text(_rollSlotController.currentIndex.toString()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RollSlot(
                    duration: Duration(milliseconds: 10000),
                    itemExtend: 300,
                    shuffleList: false,
                    rollSlotController: _rollSlotController,
                    children: values
                        .map(
                          (e) => BuildItem(
                            index: e,
                          ),
                        )
                        .toList()),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _rollSlotController.animateRandomly(),
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class BuildItem extends StatelessWidget {
  const BuildItem({
    Key key,
    this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(
        index.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 36,
        ),
      ),
    );
  }
}
