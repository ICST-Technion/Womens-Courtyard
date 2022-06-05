import 'package:flutter/material.dart';
import 'personal_file_search_page.dart' as file_search_page;
import 'home_page.dart' as home_page;
import 'attendance_search_page.dart' as attendance_search_page;
import 'search_contact.dart' as view_contact;

/// This page is in charge of the bottom navigation bar, containing:
/// * A Home screen.
/// * An attendance records screen.
/// * A files screen.
/// * A contacts screen.

//MyBottomNavigationBar()
class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({Key? key, this.username = ''}) : super(key: key);

  final String username;

  @override
  _MyBottomNavigationBarState createState() =>
      _MyBottomNavigationBarState(username: username);
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  final String username;
  int _currentIndex = 0;
  late List<Widget> _children;
  _MyBottomNavigationBarState({this.username = ''}) {
    _children = [
      home_page.HomePage(username: username),
      attendance_search_page.AttendanceSearchPage(
        username: username,
      ),
      file_search_page.PersonalFileSearchPage(username: username),
      view_contact.SearchContact(username: username),
    ];
  }

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
