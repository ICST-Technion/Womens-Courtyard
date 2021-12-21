import 'package:flutter/material.dart';
import 'Search_page.dart' as search_page;
import 'Costumer_entering.dart' as add_costumer_page;
import 'statistics.dart' as statistics_page;
import 'personal_file_search_page.dart' as file_search_page;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'מסך ראשי'),
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
        drawer: getDrawer(),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Text(
                  'שלום עו"סית',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(blurRadius: 20, spreadRadius: -15)
                      ]),
                  child: TextField(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => search_page.MyApp()));
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'חיפוש...',
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.more_vert),
                          )))),
              Padding(
                padding: const EdgeInsets.all(64.0),
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
                padding: const EdgeInsets.all(64.0),
                child: ElevatedButton(
                    child: Text("הוספת לקוחה"),
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
      )),
      IconButton(
          icon: Icon(
        Icons.info,
        size: 30,
        color: Colors.white,
      )),
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
            getListTile('רשימת תיקים', Icons.insert_drive_file, () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => file_search_page.MyApp()));
            }),
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
