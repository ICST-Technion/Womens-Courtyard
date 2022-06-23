import 'package:flutter/material.dart';
import 'package:womens_courtyard/personal_file.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:womens_courtyard/contact_edit_real.dart' as edit_contact;

class EditContactPage extends StatefulWidget {
  final ContactFile contact;

  EditContactPage(
      {Key? key,
      this.title = '',
      required this.contact,
      required this.displayEdit})
      : super(key: key);

  final String title;
  final bool displayEdit;

  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
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
                    widget.contact.firstName + " " + widget.contact.lastName,
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    widget.contact.field,
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    widget.contact.phoneNo,
                    style: TextStyle(fontSize: 23),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    widget.contact.email ?? "אין אימייל רשום במערכת",
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: ElevatedButton(
                  child: Text('צור קשר'),
                  onPressed: () {
                    UrlLauncher.launch('tel://' + widget.contact.phoneNo);
                  },
                ),
              ),
              getEditWidget(),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Title(
                  title: 'מידע נוסף',
                  color: Colors.black,
                  child: Text(widget.contact.info),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar getHomepageAppBar() {
    return AppBar(title: Text('צפייה באיש/ת קשר'), actions: [
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

  Padding getEditWidget() {
    if (widget.displayEdit) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          child: Text('לעריכה'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => edit_contact.EditContactRealPage(
                        contact: widget.contact))).then((_) => setState(() {}));
          },
        ),
      );
    } else {
      return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('לעריכה גשי לדף אנשי הקשר'));
    }
  }
}
