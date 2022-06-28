import 'package:flutter/material.dart';
import 'package:womens_courtyard/personal_file_search_page.dart'
    as file_search_page;
import 'package:womens_courtyard/home_page.dart' as home_page;
import 'package:womens_courtyard/attendance_search_page.dart'
    as attendance_search_page;
import 'package:womens_courtyard/search_contact.dart' as view_contact;

/// This page is in charge of the bottom navigation bar, containing:
/// * A Home screen.
/// * An attendance records screen.
/// * A files screen.
/// * A contacts screen.

import 'personal_file.dart';

//MyBottomNavigationBar()
class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentIndex = 0;
  late List<Widget> _children;
  _MyBottomNavigationBarState() {
    _children = [
      home_page.HomePage(),
      if (!isHQ()) attendance_search_page.AttendanceSearchPage(),
      file_search_page.PersonalFileSearchPage(),
      view_contact.SearchContact(),
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
          if (!isHQ())
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
