import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'client_entering.dart' as add_costumer_page;
import 'statistics.dart' as statistics_page;
import 'calendar.dart' as calendar_page;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.id}) : super(key: key);

  final String title;
  final String id;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var name = "אנה";
  CollectionReference users = FirebaseFirestore.instance.collection('staff');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: users.doc(widget.id).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data.data() as Map<String, dynamic>;
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
                          "שלום " + data['name'],
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
                                      builder: (context) =>
                                          statistics_page.MyApp()));
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(250, 84, 9, 0),
                                elevation: 4,
                                minimumSize: Size(150, 50),
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(30.0)))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: ElevatedButton(
                            child: Text("הוספת צעירה"),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          add_costumer_page.MyApp()));
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(250, 84, 9, 0),
                                elevation: 4,
                                minimumSize: Size(150, 50),
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(30.0)))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: ElevatedButton(
                            child: Text("יומן פעילוית"),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          calendar_page.Calendar()));
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(250, 84, 9, 0),
                                elevation: 4,
                                minimumSize: Size(150, 50),
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(30.0)))),
                      )
                    ],
                  ),
                ),
              ),
            );
          }

          return Text("loading");
        });
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
