import 'package:flutter/material.dart';
import 'package:womens_courtyard/personal_file.dart';
import 'package:womens_courtyard/client_editing.dart' as client_editing_page;
import 'package:womens_courtyard/view_contact.dart' as contact_view;

/// This file is in charge of handling the viewing of a personal page, and gives us the
/// option of editing (moves to another page).
///
/// The fields each contact has are:
/// * Phone number.
/// * Name and surname.
/// * Nationality.
/// * Phone number.
/// * Information regarding the woman.
/// * Daily sentences.
/// * Contacts.

class PersonalFileEditPage extends StatefulWidget {
  PersonalFileEditPage({Key? key, required this.person, required this.contacts})
      : super(key: key);

  final PersonalFile person;
  final List<ContactFile> contacts;

  @override
  _PersonalFileEditPageState createState() => _PersonalFileEditPageState();
}

class _PersonalFileEditPageState extends State<PersonalFileEditPage> {
  DateTime selectedDate = DateTime.now();
  List display_items = [];

  @override
  Widget build(BuildContext context) {
    //var curr_contact = contacts_data.allContacts[0];
    display_items = fill_the_list(widget.person, context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: getHomepageAppBar(),
        body: Center(
            child: ListView.builder(
                itemCount: display_items.length,
                itemBuilder: (context, index) {
                  return display_items[index];
                })),
      ),
    );
  }

  AppBar getHomepageAppBar() {
    return AppBar(title: Text('צפייה בתיק אישי'), actions: [
      IconButton(
        icon: Icon(
          Icons.info,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () {},
        tooltip:
            "מסך צפייה בתיק האישי - ניתן לצפות בפרטי התיק האישי, ועל ידי לחיצה על כפתור העריכה ניתן גם לערוך",
      )
    ]);
  }

  /// From here on we define the build of this page as a list of cards showing
  /// the different aspects of the information and links to other related pages.

  List<Card> fill_the_list(PersonalFile person, BuildContext context) {
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
      if (person.clientNotes[i] == "") {
        continue;
      }
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

    String comments_on_person = 'משפטים יומיים על הצעירה:\n';
    person.attendances.sort((a, b) => a.date.compareTo(b.date));
    for (int i = 0; i < person.attendances.length; i++) {
      comments_on_person += '\n' +
          person.attendances[i].date.year.toString() +
          "-" +
          person.attendances[i].date.month.toString() +
          "-" +
          person.attendances[i].date.day.toString() +
          ':\n' +
          person.attendances[i].comment;
    }
    toRet.add(Card(
      child: Center(
        child: Text(
          comments_on_person,
          style: TextStyle(fontSize: 20),
        ),
      ),
    ));

    toRet.add(Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          'אנשי קשר:',
          style: TextStyle(fontSize: 20),
        ),
      ),
    ));

    for (ContactFile c in widget.contacts) {
      toRet.add(Card(
        child: new ListTile(
          leading: Icon(Icons.contact_page),
          title: new Text(c.firstName + " " + c.lastName),
          subtitle: new Text(c.field),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => contact_view.EditContactPage(
                          contact: c,
                          displayEdit: false,
                        ))).then((value) => setState(() {}));
          },
        ),
        margin: const EdgeInsets.all(0.0),
      ));
    }

    toRet.add(Card(
        child: ElevatedButton(
            child: Text('מעבר לטפסים', style: TextStyle(fontSize: 20)),
            onPressed: () {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => forms.FormsButtonsPage()));
            },
            style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(250, 84, 9, 0),
                elevation: 4,
                minimumSize: Size(150, 50),
                textStyle: TextStyle(color: Colors.white, fontSize: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))))));

    toRet.add(Card(
        child: ElevatedButton(
            child: Text('לעריכה', style: TextStyle(fontSize: 20)),
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              client_editing_page.EditClientPage(
                                  person: person,
                                  initialContacts: widget.contacts)))
                  .then((value) => setState(() {}));
            },
            style: ElevatedButton.styleFrom(
                elevation: 4,
                minimumSize: Size(150, 50),
                textStyle: TextStyle(color: Colors.white, fontSize: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))))));
    return toRet;
  }
}
