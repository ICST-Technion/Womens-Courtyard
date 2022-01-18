import 'package:flutter/material.dart';
import 'personal_file_search_page.dart' as file_search_page;
import 'Home_page.dart' as home_page;
import 'Search_full_page.dart' as daily_search_page;
import 'searchContact.dart' as view_contact;
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initiallization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initiallization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text(snapshot.error.toString(),
                      textDirection: TextDirection.ltr)));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyBottomNavigationBar(),
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    home_page.MyHomePage(),
    daily_search_page.MyHomePage(),
    file_search_page.HomePage(),
    view_contact.HomePage(),
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'מסך הבית',
              backgroundColor: Colors.purpleAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'נוכחות יומית',
              backgroundColor: Colors.purpleAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_drive_file),
              label: 'תיקים',
              backgroundColor: Colors.purpleAccent),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box_rounded),
              label: 'אנשי קשר',
              backgroundColor: Colors.purpleAccent),
        ],
        backgroundColor: Colors.purpleAccent,
        fixedColor: Colors.white,
      ),
    );
  }
}
