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
                body: Center(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Center(
                            child: Text(
                          'שלום ' + data['name'],
                          style: TextStyle(fontSize: 30),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Center(
                            child: Text(
                          'סניף ' + AppUser().branch!,
                          style: TextStyle(fontSize: 20),
                        )),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: ElevatedButton(
                                child: Text('סטטיסטיקה'),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              statistics_page.TaskHomePage()));
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 4,
                                    minimumSize: Size(150, 50),
                                    textStyle: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)))),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          // if(!isHQ())
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: ElevatedButton(
                                child: Text('הוספת צעירה'),
                                onPressed: () {
                                  if (!isHQ())
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                add_client_page
                                                    .AddClientPage()));
                                },
                                style: (!isHQ())
                                    ? ElevatedButton.styleFrom(
                                        elevation: 4,
                                        minimumSize: Size(150, 50),
                                        textStyle: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0)))
                                    : ElevatedButton.styleFrom(
                                        primary: Color.fromRGBO(250, 84, 9, 0),
                                        elevation: 4,
                                        minimumSize: Size(150, 50),
                                        textStyle: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0)))),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: ElevatedButton(
                                child: Text('יומן פעילוית'),
                                onPressed: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             calendar_page.Calendar()));
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
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: ElevatedButton(
                                child: Text('הוספת צוות'),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              registration_screen
                                                  .RegistrationScreen()));
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 4,
                                    minimumSize: Size(150, 50),
                                    textStyle: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)))),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: ElevatedButton(
                                child: Text('התנתקות'),
                                onPressed: () {
                                  Navigator.popUntil(
                                      context,
                                      ModalRoute.withName(
                                          Navigator.defaultRouteName));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              login_page.LoginScreen()));
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 4,
                                    minimumSize: Size(150, 50),
                                    textStyle: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)))),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }

          return Text('loading');
        });
  }

  AppBar getHomepageAppBar() {
    return AppBar(
        title: Center(child: Text('דף הבית')),
        automaticallyImplyLeading: false,
        actions: [Padding(padding: const EdgeInsets.all(30.0))]);
  }
}
