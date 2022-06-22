import 'dart:async';
import 'package:flutter/material.dart';
import 'package:womens_courtyard/personal_file.dart';

class SearchContactForClient extends StatefulWidget {
  SearchContactForClient({Key? key, this.title = ''}) : super(key: key);

  final String title;

  @override
  _SearchContactForClientState createState() =>
      new _SearchContactForClientState();
}

class _SearchContactForClientState extends State<SearchContactForClient> {
  TextEditingController controller = new TextEditingController();

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    try {
      _contactDetails = [];
      final response = await getContactsDocs();
      for (final doc in response) {
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
                Navigator.of(context, rootNavigator: true).pop(contacts[index]);
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
