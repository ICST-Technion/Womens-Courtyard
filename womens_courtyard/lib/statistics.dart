// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:womens_courtyard/taskhomepage.dart';
import 'package:womens_courtyard/attendance_search_page.dart' as search_page;

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: StatisticsPage(title: 'סטטיסטיקה'),
    );
  }
}

class StatisticsPage extends StatefulWidget {
  StatisticsPage({Key? key, this.title = ''}) : super(key: key);

  final String title;

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: getHomepageAppBar(),
        body: SingleChildScrollView(
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              children: <Widget>[
                StatisticHeadline(),
                PersonalStatisticWidget(),
                // NamesRow(),
                // IdRow(),
                SearchWidget(),
                SendRequest(),
                GeneralStatisticWidget(),
                DateRow(initialDate: _dateTime ?? DateTime.now()),
                SendRequest()
                // Row(children: <Widget>[
                //   Flexible(child: getStartDateWidget(context)),
                //   Flexible(child: getEndDateWidget(context))
                // ])
              ],
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Padding SendRequest() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: ElevatedButton(
          child: Text('שלח בקשה'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TaskHomePage()));
          },
          style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(250, 84, 9, 0),
              elevation: 4,
              minimumSize: Size(10, 10),
              textStyle: TextStyle(color: Colors.white, fontSize: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)))),
    );
  }

  ElevatedButton SendBtn() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            side: BorderSide(
              width: 3,
            ), //border width and color
            elevation: 3, //elevation of button
            shape: ContinuousRectangleBorder(
                //to set border radius to button
                borderRadius: BorderRadius.circular(30))),
        onPressed: () {},
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: 'שלח בקשה'),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Icon(Icons.send),
                ),
              ),
            ],
          ),
        ));
  }

  AppBar getHomepageAppBar() {
    return AppBar(title: Text('סטטיסטיקה'), actions: [
      IconButton(
        icon: Icon(
          Icons.account_circle,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(
          Icons.info,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
    ]);
  }

  Drawer getDrawer() {
    return Drawer(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 28, horizontal: 0),
      color: Colors.purpleAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Divider(),
            getListTile('נוכחות יומית', Icons.calendar_today, () {}),
            Divider(),
            getListTile('רשימת תיקים', Icons.insert_drive_file, () {}),
            Divider(),
            getListTile(
                'רשימת אנשי קשר מקצועיים', Icons.account_box_rounded, () {}),
            Divider()
          ]),
        ],
      ),
    ));
  }

  ListTile getListTile(text, icon, action) {
    return ListTile(
      title: Text(text, style: TextStyle(fontSize: 19, color: Colors.white)),
      trailing: Icon(icon, color: Colors.white),
      onTap: action,
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(blurRadius: 20, spreadRadius: -15)]),
        child: TextField(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          search_page.AttendanceSearchPage()));
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'חיפוש...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {},
                ))));
  }
}

class IdRow extends StatelessWidget {
  const IdRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Flexible(
                child: TextField(
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'תעודת זהות',
              ),
            )),
            SizedBox(width: 20.0)
          ],
        ));
  }
}

class NamesRow extends StatelessWidget {
  const NamesRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Flexible(
                child: TextField(
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'שם פרטי',
              ),
            )),
            SizedBox(
              width: 20.0,
            ),
            Flexible(
                child: TextField(
                    decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'שם משפחה',
            ))),
            SizedBox(
              width: 20.0,
            ),
          ],
        ));
  }
}

class DateRow extends StatelessWidget {
  const DateRow({Key? key, required this.initialDate}) : super(key: key);

  final DateTime initialDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Flexible(
                child: Column(
              children: <Widget>[
                SizedBox(
                    width: 200.0,
                    child: StartDateWidget(initialDate: initialDate))
              ],
            )),
            SizedBox(
              width: 20.0,
            ),
            Flexible(
                child: Column(
              children: <Widget>[
                SizedBox(
                    width: 200.0,
                    child: EndDateWidget(initialDate: initialDate))
              ],
            )),
            SizedBox(
              width: 20.0,
            ),
          ],
        ));
  }
}

class EndDateWidget extends StatelessWidget {
  const EndDateWidget({Key? key, required this.initialDate}) : super(key: key);

  final DateTime initialDate;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Text('תאריך סוף'),
        onPressed: () {
          showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: DateTime(2001),
                  lastDate: DateTime(2021))
              .then((date) {
            // setState(() {
            //   _dateTime = date;
          });
        });
  }
}

class StartDateWidget extends StatelessWidget {
  const StartDateWidget({Key? key, required this.initialDate})
      : super(key: key);

  final DateTime initialDate;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Text('תאריך התחלה'),
        onPressed: () {
          showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: DateTime(2001),
                  lastDate: DateTime(2021))
              .then((date) {
            // setState(() {
            //   _dateTime = date;
          });
        });
  }
}

class PersonalStatisticWidget extends StatelessWidget {
  const PersonalStatisticWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64.0, vertical: 20.0),
      child: OutlinedButton(onPressed: () {}, child: Text('סטטיסטיקה אישית')),
    );
  }
}

class GeneralStatisticWidget extends StatelessWidget {
  const GeneralStatisticWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 40.0, right: 40.0, top: 20.0, bottom: 20.0),
      child: OutlinedButton(onPressed: () {}, child: Text('סטטיסטיקה כללית')),
    );
  }
}

class StatisticHeadline extends StatelessWidget {
  const StatisticHeadline({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 40.0),
      child: Text(
        'סטטיסטיקה',
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}
