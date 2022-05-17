import 'package:flutter/material.dart';
import 'contact.dart' as contact;
import 'contacts_data.dart' as contacts_data;
import 'personal_file.dart';
import 'forms_buttons.dart' as forms;
import 'bottom_navigation_bar.dart' as bottom_navigation_bar;
import 'client_editing.dart' as client_editing_page;

class PersonalFileEditPage extends StatefulWidget {
  PersonalFileEditPage(
      {Key? key, this.title = "", this.username = '', required this.person})
      : super(key: key);

  final PersonalFile person;
  final String title;
  List display_items = List<String>.empty();
  final String username;

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
    widget.display_items =
        fill_the_list(widget.person, context, widget.username);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: getHomepageAppBar(),
        body: Center(
            child: ListView.builder(
                itemCount: widget.display_items.length,
                itemBuilder: (context, index) {
                  return widget.display_items[index];
                })),
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

List fill_the_list(PersonalFile person, BuildContext context, String username) {
  List<Card> toRet = [];
  toRet.add(Card(
    child: Center(
      child: Text(
        'שם פרטי: ' + person.firstName,
        style: TextStyle(fontSize: 20),
      ),
    ),
  ));
  toRet.add(Card(
    child: Center(
      child: Text(
        'שם משפחה: ' + person.lastName,
        style: TextStyle(fontSize: 20),
      ),
    ),
  ));
  toRet.add(Card(
    child: Center(
      child: Text(
        'לאום: ' + person.nationality,
        style: TextStyle(fontSize: 20),
      ),
    ),
  ));
  toRet.add(Card(
    child: Center(
      child: Text(
        'תעודת זהות: ' + person.idNo!,
        style: TextStyle(fontSize: 20),
      ),
    ),
  ));
  toRet.add(Card(
    child: Center(
      child: Text(
        'מספר טלפון: ' + person.phoneNo,
        style: TextStyle(fontSize: 20),
      ),
    ),
  ));

  String data_on_person = 'מידע על הצעירה:\n';
  for (int i = 0; i < person.clientNotes.length; i++) {
    data_on_person += '\n' + person.clientNotes[i];
  }
  toRet.add(Card(
    child: Center(
      child: Text(
        data_on_person,
        style: TextStyle(fontSize: 20),
      ),
    ),
  ));

  toRet.add(Card(
      child: ElevatedButton(
    child: Text('מעבר לטפסים', style: TextStyle(fontSize: 20)),
    onPressed: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => forms.FormsButtonsPage()));
    },
  )));
  toRet.add(Card(
      child: ElevatedButton(
    child: Text('לעריכה', style: TextStyle(fontSize: 20)),
    onPressed: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => client_editing_page.EditClientPage(
                  person: person, username: username)));
    },
  )));
  return toRet;
}
