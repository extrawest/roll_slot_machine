import 'package:flutter/material.dart';
import 'package:roll_slot_machine/roll_slot.dart';
import 'package:roll_slot_machine/roll_slot_controller.dart';

class CardsPage extends StatelessWidget {
  List<ActivityGroup> activityGroupList = [
    ActivityGroup(
      name: 'Summer Friends',
      activities: [
        Activity(
          name: 'Sahil Biraaa',
          imageUrl:
              'https://img.freepik.com/free-psd/two-beer-bottles-mockup-beach_23-2148198183.jpg?size=626&ext=jpg',
        ),
        Activity(
          name: 'Yüzmee',
          imageUrl:
              'https://i.pinimg.com/736x/0a/7c/5c/0a7c5ce4313bb326240ee412e59fd381.jpg',
        ),
      ],
    ),
    ActivityGroup(
      name: 'Summer Friends',
      activities: [
        Activity(
          name: 'Sahil Biraaa',
          imageUrl:
              'https://img.freepik.com/free-psd/two-beer-bottles-mockup-beach_23-2148198183.jpg?size=626&ext=jpg',
        ),
        Activity(
          name: 'Yüzmee',
          imageUrl:
              'https://i.pinimg.com/736x/0a/7c/5c/0a7c5ce4313bb326240ee412e59fd381.jpg',
        ),
      ],
    ),
  ];

  CardsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collect Your Activities'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: activityGroupList
            .map((e) => ActivityGroupCard(
                  activityGroup: e,
                ))
            .toList(),
      ),
    );
  }
}

class ActivityGroup {
  final String name;
  final List<Activity> activities;

  ActivityGroup({this.name, this.activities});
}

class Activity {
  final String name;
  final String imageUrl;

  Activity({this.name, this.imageUrl});
}

class ActivityGroupCard extends StatelessWidget {
  final ActivityGroup activityGroup;

  const ActivityGroupCard({Key key, this.activityGroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RandomActivityPage(
            activities: activityGroup.activities,
          ),
        ),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                activityGroup.name,
              ),
              Expanded(
                child: Image.network(
                  activityGroup.activities.first.imageUrl,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({Key key, this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 2,
      child: Card(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                activity.name,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    child: Image.network(
                      activity.imageUrl,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RandomActivityPage extends StatefulWidget {
  final List<Activity> activities;

  const RandomActivityPage({Key key, this.activities}) : super(key: key);

  @override
  _RandomActivityPageState createState() => _RandomActivityPageState();
}

class _RandomActivityPageState extends State<RandomActivityPage> {
  var _rollSlotController = RollSlotController();

  Widget _currentWidget;

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
        title: Text((_currentWidget as ActivityCard)?.activity?.name ?? 'Roll The Machine'),
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
                    itemExtend: 250,
                    shuffleList: false,
                    rollSlotController: _rollSlotController,
                    onItemSelected: onItemSelected,
                    children: widget.activities
                        .map(
                          (e) => ActivityCard(
                            activity: e,
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

  void onItemSelected({int currentIndex, Widget currentWidget}) {
    setState(() {
      _currentWidget = currentWidget;
    });
  }
}
