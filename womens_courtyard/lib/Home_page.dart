import 'package:flutter/material.dart';
import 'Costumer_entering.dart' as add_costumer_page;
import 'statistics.dart' as statistics_page;
import 'calendar.dart' as calendar_page;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var name = "אנה";
  var id = "1";
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: getHomepageAppBar(),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Text(
                  "שלום " + name,
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: ElevatedButton(
                    child: Text("סטטיסטיקה"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => statistics_page.MyApp()));
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(250, 84, 9, 0),
                        elevation: 4,
                        minimumSize: Size(150, 50),
                        textStyle: TextStyle(color: Colors.white, fontSize: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)))),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: ElevatedButton(
                    child: Text("הוספת צעירה"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => add_costumer_page.MyApp()));
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(250, 84, 9, 0),
                        elevation: 4,
                        minimumSize: Size(150, 50),
                        textStyle: TextStyle(color: Colors.white, fontSize: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)))),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: ElevatedButton(
                    child: Text("יומן פעילוית"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => calendar_page.Calendar()));
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(250, 84, 9, 0),
                        elevation: 4,
                        minimumSize: Size(150, 50),
                        textStyle: TextStyle(color: Colors.white, fontSize: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)))),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar getHomepageAppBar() {
    return AppBar(title: Text('דף הבית'), actions: [
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
}
