import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:womens_courtyard/meeting.dart';
import 'package:womens_courtyard/meetings.dart';
import 'package:womens_courtyard/add_event.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return (appointments!)[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return (appointments!)[index].to;
  }

  @override
  String getSubject(int index) {
    return (appointments!)[index].eventName;
  }

  @override
  Color getColor(int index) {
    return (appointments!)[index].background;
  }

  @override
  bool isAllDay(int index) {
    return (appointments!)[index].isAllDay;
  }
}

class _CalendarState extends State<Calendar> {
  List<Meeting> _getDataSource() {
    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: getHomepageAppBar(),
        body: Scaffold(
          body: SfCalendar(
            view: CalendarView.week,
            allowedViews: <CalendarView>[
              CalendarView.week,
              CalendarView.month,
              CalendarView.schedule
            ],
            dataSource: MeetingDataSource(_getDataSource()),
            showNavigationArrow: true,
            monthViewSettings: MonthViewSettings(
                appointmentDisplayMode:
                    MonthAppointmentDisplayMode.appointment),
            // onTap: (CalendarTapDetails details) {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => AddEventPage(details.date)));
            //   // dynamic appointment = details.appointments;
            //   // DateTime date = details.date;
            //   // CalendarElement element = details.targetElement;
            // },
          ),
          floatingActionButton: FloatingActionButton(
            // When the user presses the button, show an alert dialog containing
            // the text that the user has entered into the text field.
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddEventPage()));
            },
            tooltip: 'הוסיפי פעילות ליומן',
            child: const Icon(Icons.add),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

AppBar getHomepageAppBar() {
  return AppBar(title: Text('יומן פעילויות'), actions: [
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
