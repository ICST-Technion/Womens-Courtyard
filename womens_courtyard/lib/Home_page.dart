import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:womens_courtyard/client_entering.dart' as add_client_page;
import 'package:womens_courtyard/taskhomepage.dart' as statistics_page;
import 'package:womens_courtyard/register_screen.dart' as registration_screen;
import 'package:womens_courtyard/user.dart';
import 'package:womens_courtyard/login_screen.dart' as login_page;
import 'personal_file.dart';

/// The homepage of the application.
/// It doesn't hold important information but holds links to features of the app
/// not noted in the bottom navigation bar.
/// Including:
///
/// * Statistics.
/// * Adding a user (Both crew and non-crew).
/// * Calendar.

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.title = ''}) : super(key: key);

  final String title;
  final String username = AppUser().username ?? "";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var name = 'אנה';
  CollectionReference users = FirebaseFirestore.instance.collection('staff');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: users.doc(widget.username).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.hasData && snapshot.data == null) {
            return Text('Document does not exist');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data?.data() as Map<String, dynamic>;
            return Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  appBar: getHomepageAppBar(),
                  body: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        PaddedText('שלום ' + data['name'], 30),
                        PaddedText('סניף ' + AppUser().branch!, 20),
                        Center(
                          child: Column(children: [
                            MenuButton('סטטיסטיקה', () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          statistics_page.TaskHomePage()));
                            }),
                            MenuButton('הוספת צעירה', () {
                              if (!isHQ())
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            add_client_page.AddClientPage()));
                            }, isHQ: isHQ()),
                            MenuButton('הוספת צוות', () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => registration_screen
                                          .RegistrationScreen()));
                            }),
                            MenuButton('התנתקות', () {
                              Navigator.popUntil(
                                  context,
                                  ModalRoute.withName(
                                      Navigator.defaultRouteName));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          login_page.LoginScreen()));
                            })
                          ]),
                        ),
                      ],
                    ),
                  ),
                  // This trailing comma makes auto-formatting nicer for build methods.
                ));
          }

          return Text('loading');
        });
  }

  Widget MenuButton(String txt, Function() buttonFunc, {isHQ = false}) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: ElevatedButton(
          child: Text(txt),
          onPressed: buttonFunc,
          style: ElevatedButton.styleFrom(
              elevation: 4,
              primary: isHQ ? Color.fromRGBO(250, 84, 9, 0) : Colors.purple,
              padding: EdgeInsets.all(4),
              minimumSize: Size(180, 60),
              textStyle: TextStyle(color: Colors.white, fontSize: 22),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)))),
    );
  }

  Padding PaddedText(String txt, double fontSize) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
          child: Text(
        txt,
        style: TextStyle(fontSize: fontSize),
      )),
    );
  }

  AppBar getHomepageAppBar() {
    return AppBar(
        title: Text('דף הבית', textAlign: TextAlign.center),
        automaticallyImplyLeading: false,
        actions: [
          Padding(padding: const EdgeInsets.all(30.0)),
          IconButton(
            icon: Icon(
              Icons.info,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {},
            tooltip:
                "עמוד הבית - מכאן אפשר לעבור לאזורים רבים באפליקציה, שימו לב גם לאופציות בתחתית המסך.",
          ),
        ]);
  }
}
