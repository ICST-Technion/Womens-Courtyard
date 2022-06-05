import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:womens_courtyard/meetings.dart';
import 'client_entering.dart' as main_page;
import 'meeting.dart';
import 'calendar.dart';
import 'package:date_format/date_format.dart';
// import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// This file is in charge of handling the adding of an event to the calendar.
///
/// The fields each contact has are:
/// * Time.
/// * Date.
/// * Room.
/// * Name of activity.
///
/// Only by adding valid details, the worker is able to add an event to the
/// calendar.

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  String? _selectedRoom;
  final meetingNameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    meetingNameController.dispose();
    super.dispose();
  }

  String? _setTime, _setDate;

  String? _hour, _minute, _time;

  String? dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour! + ' : ' + _minute!;
        _timeController.text = _time!;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, ' ', am]).toString();
      });
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, ' ', am]).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _height = MediaQuery.of(context).size.height;
    // _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    // return Directionality(
    //     textDirection: TextDirection.rtl,
    //     child: Scaffold(
    return Scaffold(
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
              child: Text(
                'הוספת פעילות',
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextField(
              decoration: new InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'שם הפעילות',
              ),
              controller: meetingNameController,
            ),
            Text(
              'בחרי תאריך',
              style: TextStyle(fontSize: 15),
              // style: TextStyle(
              //     fontStyle: FontStyle.italic,
              //     fontWeight: FontWeight.w600,
              //     letterSpacing: 0.5),
            ),
            InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: TextFormField(
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                enabled: false,
                keyboardType: TextInputType.text,
                controller: _dateController,
                onSaved: (String? val) {
                  _setDate = val;
                },
                decoration: InputDecoration(
                    disabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    // labelText: 'Time',
                    contentPadding: EdgeInsets.only(top: 0.0)),
              ),
            ),
            Text(
              'בחרי שעה',
              style: TextStyle(fontSize: 15),
            ),
            InkWell(
              onTap: () {
                _selectTime(context);
              },
              child: TextFormField(
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
                onSaved: (String? val) {
                  _setTime = val;
                },
                enabled: false,
                keyboardType: TextInputType.text,
                controller: _timeController,
                decoration: InputDecoration(
                    disabledBorder:
                        UnderlineInputBorder(borderSide: BorderSide.none),
                    // labelText: 'Time',
                    contentPadding: EdgeInsets.all(5)),
              ),
            ),
            DropdownButtonFormField(
              decoration: new InputDecoration(
                border: UnderlineInputBorder(),
              ),
              //hint: Text('בחרי תחום עיסוק'),
              hint: _selectedRoom == null
                  ? Text('בחרי חדר עבור הפעילות')
                  : Text(
                      _selectedRoom!,
                      style: TextStyle(color: Colors.purple),
                    ),
              value: _selectedRoom,
              isExpanded: true,
              iconSize: 30.0,
              style: TextStyle(color: Colors.purple),
              items: rooms.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: new Text(category),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(
                  () {
                    _selectedRoom = newValue as String?;
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(64.0),
              child: ElevatedButton(
                  child: Text('סיום ושמירה'),
                  onPressed: () {
                    // ToDo: update all values
                    // var date = DateTime.parse(_setDate + _setTime);
                    // meetings.add(Meeting(meetingNameController.text,
                    // _selectedRoom, date, date, false));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Calendar()));
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(250, 84, 9, 0),
                      elevation: 4,
                      minimumSize: Size(150, 50),
                      textStyle: TextStyle(color: Colors.white, fontSize: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)))),
            ),
          ],
        ),
      ),
    );
  }

  AppBar getHomepageAppBar() {
    return AppBar(title: Text('הוספת פעילות'), actions: [
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
