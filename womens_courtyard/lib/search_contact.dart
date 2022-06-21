import 'dart:async';
import 'package:flutter/material.dart';
import 'package:womens_courtyard/add_contact.dart' as add_contact_page;
import 'package:womens_courtyard/edit_contact.dart' as edit_contact_page;
import 'package:womens_courtyard/personal_file.dart';

class SearchContact extends StatefulWidget {
  SearchContact({Key? key, this.title = ''}) : super(key: key);

  final String title;

  @override
  _SearchContactState createState() => new _SearchContactState();
}

class _SearchContactState extends State<SearchContact> {
  TextEditingController controller = new TextEditingController();

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    try {
      _contactDetails = [];
      final response = await getContactsDocs();
      for (final doc in response.docs) {
        _contactDetails.add(ContactFile.fromDoc(doc));
      }
      _contactDetails.sort((a, b) => a.firstName.compareTo(b.firstName));
      setState(() {});
    } catch (e) {
      print('caught $e');
    }
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
                    ? createFilesWidget(_searchResult)
                    : createFilesWidget(_contactDetails)),
            Padding(
              padding: const EdgeInsets.all(64.0),
              child: ElevatedButton(
                  child: Text('הוספת איש קשר'),
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    add_contact_page.AddContactPage()))
                        .then((_) => getUserDetails());
                  },
                  style: ElevatedButton.styleFrom(
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
      if (contact.firstName.contains(text)) _searchResult.add(contact);
    });
    _contactDetails.sort((a, b) => a.firstName.compareTo(b.firstName));

    setState(() {});
  }

  Container createFilesWidget(List<ContactFile> contacts) {
    return Container(
      height: 750,
      child: new ListView.builder(
        // Search query results
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return new Card(
            child: new ListTile(
              leading: Icon(Icons.contact_page),
              title: new Text(contacts[index].firstName),
              subtitle: new Text(contacts[index].field),
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                edit_contact_page.EditContactPage(
                                    contact: contacts[index])))
                    .then((value) => getUserDetails());
              },
            ),
            margin: const EdgeInsets.all(0.0),
          );
        },
      ),
    );
  }
}

List<ContactFile> _searchResult = [];

List<ContactFile> _contactDetails = [];
