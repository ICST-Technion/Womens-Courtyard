import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:womens_courtyard/personal_file.dart';

class AttendancePage extends StatefulWidget {
  AttendancePage({Key? key, this.title = '', required this.file})
      : super(key: key);

  final PersonalFile file;
  final String title;

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  DateTime selectedDate = DateTime.now();
  AttendancePoster? attendancePoster;
  final TextEditingController dailySentenceController =
      new TextEditingController();

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
    this.attendancePoster = AttendancePoster(clientKey: widget.file.key);

    final dailySentenceField = TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: dailySentenceController,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          dailySentenceController.text = value ?? '';
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.text_fields),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'משפט יומי',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: getHomepageAppBar(),
        body: Center(
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
              Flexible(child: dailySentenceField),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(64.0),
                child: ElevatedButton(
                    child: Text('הזנה וסיום'),
                    onPressed: () {
                      this.attendancePoster!.postAttendance(
                          selectedDate, dailySentenceController.text);
                      Navigator.of(context, rootNavigator: true).pop();
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
          Icons.info,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () {},
        tooltip:
            "מסך הזנת נוכחות - ניתן להזין תאריך מסוים וגם משפט יומי על הצעירה",
      )
    ]);
  }
}

class AttendancePoster {
  AttendancePoster({required this.clientKey});

  final String clientKey;

  void postAttendance(DateTime currDate, String dailySentence) async {
    updatePersonalFile(this.clientKey, {
      'attendances': FieldValue.arrayUnion([
        {'date': currDate, 'comment': dailySentence}
      ])
    })
        .then((_) => print('attendance updated'))
        .catchError((e) => print('attendance update failed $e'));
    ;
  }
}
