import 'dart:async';
import 'package:flutter/material.dart';
import 'package:womens_courtyard/contact.dart';
import 'package:womens_courtyard/contacts_data.dart';
import 'addContact.dart' as add_contact_page;
import 'edit_contact.dart' as edit_contact_page;

void main() => runApp(new MaterialApp(
      home: new HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = new TextEditingController();

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      for (Contact contact in allContacts) {
        _contactDetails.add(contact);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('חיפוש אשת קשר'),
          elevation: 0.0,
        ),
        body: new Column(
          children: <Widget>[
            new Container(
              color: Theme.of(context).primaryColor,
              child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Card(
                  child: Container(
                    child: new ListTile(
                      leading: new Icon(Icons.search),
                      title: new TextField(
                        controller: controller,
                        decoration: new InputDecoration(
                            hintText: 'חיפוש', border: InputBorder.none),
                        onChanged: onSearchTextChanged,
                      ),
                      trailing: new IconButton(
                        icon: new Icon(Icons.cancel),
                        onPressed: () {
                          controller.clear();
                          onSearchTextChanged('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            new Expanded(
                child: _searchResult.length != 0 || controller.text.isNotEmpty
                    ? FileList(list: _searchResult)
                    : FileList(list: _contactDetails)),
            Padding(
              padding: const EdgeInsets.all(64.0),
              child: ElevatedButton(
                  child: Text("הוספת איש קשר"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => add_contact_page.MyApp()));
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(250, 84, 9, 0),
                      elevation: 4,
                      minimumSize: Size(150, 50),
                      textStyle: TextStyle(color: Colors.white, fontSize: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)))),
            )
          ],
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _contactDetails.forEach((contact) {
      if (contact.name.contains(text) || contact.name.contains(text))
        _searchResult.add(contact);
    });

    setState(() {});
  }
}

class FileList extends StatelessWidget {
  final List<Contact> list;
  FileList({this.list});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 750,
      child: new ListView.builder(
        // Search query results
        itemCount: list.length,
        itemBuilder: (context, index) {
          return new Card(
            child: new ListTile(
              leading: Icon(Icons.contact_page),
              title: new Text(list[index].name),
              subtitle: new Text(
              list[index].occupation),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => edit_contact_page.MyApp()));
              },
            ),
            margin: const EdgeInsets.all(0.0),
          );
        },
      ),
    );
  }
}

List<Contact> _searchResult = [];

List<Contact> _contactDetails = [];
