import 'package:flutter/material.dart';
import 'contact.dart' as contact;
import 'contacts_data.dart' as contacts_data;
import 'personal_file.dart';
import 'forms_buttons.dart' as forms;
import 'bottom_navigation_bar.dart' as bottom_navigation_bar;

class PersonalFileEditPage extends StatefulWidget {
  PersonalFileEditPage({Key? key, this.title = "", required this.person})
      : super(key: key);

  final PersonalFile person;
  final String title;

  @override
  _PersonalFileEditPageState createState() => _PersonalFileEditPageState();
}

class _PersonalFileEditPageState extends State<PersonalFileEditPage> {
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
    var curr_contact = contacts_data.allContacts[0];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: getHomepageAppBar(),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(15.0),
            children: <Widget>[
              Card(
                //padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    'שם פרטי: ' + widget.person.firstName,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Card(
                //padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    'שם משפחה: ' + widget.person.lastName,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Card(
                //padding: const EdgeInsets.all(3.0),
                child: Text(
                  'לאום: ' + widget.person.nationality,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Card(
                //padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    'תעודת זהות: ' + widget.person.idNo!,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Card(
                //padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    'מספר טלפון: ' + widget.person.phoneNo,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Card(
                //padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    'מידע על הצעירה:\n' + widget.person.clientNotes.last,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Card(
                //padding: const EdgeInsets.all(40.0),
                child: ElevatedButton(
                  child: Text("מעבר לטפסים"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => forms.FormsButtonsPage()));
                  },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: ElevatedButton(
              //       child: Text("לעריכה"),
              //       onPressed: () {},
              //       style: ElevatedButton.styleFrom(
              //           primary: Color.fromRGBO(250, 84, 9, 0),
              //           elevation: 4,
              //           minimumSize: Size(100, 50),
              //           textStyle: TextStyle(color: Colors.white, fontSize: 20),
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(30.0)))),
              // ),
              SizedBox(
                height: 15.0,
              ),
              Card(
                //padding: const EdgeInsets.all(10.0),
                child: Text(
                  'אנשי קשר:' //TODO: add a list of contacts
                  ,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar getHomepageAppBar() {
    return AppBar(title: Text('צפייה בתיק אישי'), actions: [
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
