import 'package:flutter/material.dart';

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

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
                      boxShadow: [BoxShadow(blurRadius: 20, spreadRadius: -15)]),
                  child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'חיפוש...',
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.more_vert),
                          )))),
              Padding(
                padding: const EdgeInsets.all(64.0),
                child: ElevatedButton
                  (child: Text("סטטיסטיקה"),
                    onPressed: (){}, style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(250, 84, 9, 0),
                        elevation: 4,
                        minimumSize: Size(150, 50),
                        textStyle: TextStyle(color: Colors.white, fontSize: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)))),
              ),
              Padding(
                padding: const EdgeInsets.all(64.0),
                child: ElevatedButton
                  (child: Text("הוספת לקוחה"),
                    onPressed: (){}, style: ElevatedButton.styleFrom(
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
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
  AppBar getHomepageAppBar(){
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
                getListTile('נוכחות יומית', Icons.calendar_today, () {
                }),
                Divider(),

                getListTile('רשימת תיקים', Icons.insert_drive_file, () {

                }),
                Divider(),

                getListTile('רשימת אנשי קשר מקצועיים', Icons.account_box_rounded, () {

                }),

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
