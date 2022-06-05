import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main.dart' as main_page;
import 'bottom_navigation_bar.dart' as bottom_navigation_bar;
import 'personal_file.dart';

/// This file is in charge of handling the adding of an attendance record for a
/// certain participant.
///
/// each attendance form contains a date and a comment, and is attached to a
/// certain woman and her personal file.


class AttendancePage extends StatefulWidget {
  AttendancePage(
      {Key? key, this.title = '', this.username = '', required this.file})
      : super(key: key);

  final PersonalFile file;
  final String title;
  final String username;

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
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
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(15.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    widget.file.firstName + ' ' + widget.file.lastName,
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                      child: Text(
                    selectedDate.day.toString() +
                        '.' +
                        selectedDate.month.toString() +
                        '.' +
                        selectedDate.year.toString(),
                    style: TextStyle(fontSize: 20),
                  )),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    'בחר תאריך',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(64.0),
                child: ElevatedButton(
                    child: Text('הזנה וסיום'),
                    onPressed: () {
                      postAttendance(selectedDate, widget.file.key);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  bottom_navigation_bar.MyBottomNavigationBar(
                                      username: widget.username)));
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 4,
                        minimumSize: Size(150, 50),
                        textStyle: TextStyle(color: Colors.white, fontSize: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar getHomepageAppBar() {
    return AppBar(title: Text('הזנת נוכחות'), actions: [
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

/// A function that is in charge for adding the new attendance record (date and
/// comment) to firebase.


void postAttendance(DateTime currDate, String clientKey) async {
  CollectionReference ref = FirebaseFirestore.instance.collection('clients');
  ref
      .doc(clientKey)
      .update({
        'attendances': FieldValue.arrayUnion([
          {'date': currDate, 'comment': ''}
        ])
      })
      .then((_) => print('attendance updated'))
      .catchError((e) => print('attendance update failed $e'));
  ;
}
