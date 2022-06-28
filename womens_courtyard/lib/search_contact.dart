import 'dart:async';
import 'package:flutter/material.dart';
import 'package:womens_courtyard/add_contact.dart' as add_contact_page;
import 'package:womens_courtyard/view_contact.dart' as edit_contact_page;
import 'package:womens_courtyard/personal_file.dart';

/// A file in charge of searching a contact.
/// While searching, the app helps with suggestions of contacts that match
/// the current text in the search bar.
/// When a suggestion is pressed, it leads the user to the contact
/// selected.

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
      for (final doc in response) {
        _contactDetails.add(ContactFile.fromDoc(doc));
      }
      _contactDetails.sort((a, b) => a.firstName.compareTo(b.firstName));
      if (mounted) {
        setState(() {});
      }
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
            actions: [
              IconButton(
                icon: Icon(
                  Icons.info,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {},
                tooltip:
                    "מסך חיפוש אשת קשר - ניתן לחפש חלק מהטקסט והאפליקציה תשלים לאופציות שונות",
              )
            ]),
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
                  child: Text('הוספת איש/ת קשר'),
                  onPressed: () {
                    if (!isHQ())
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      add_contact_page.AddContactPage()))
                          .then((_) => getUserDetails());
                  },
                  style: (!isHQ())
                      ? ElevatedButton.styleFrom(
                          elevation: 4,
                          minimumSize: Size(150, 50),
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)))
                      : ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(250, 84, 9, 0),
                          elevation: 4,
                          minimumSize: Size(150, 50),
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)))),
            )
          ],
        ),
      ),
    );
  }

  /// A function designed to deal with a certain text change -
  /// For example, while searching if a new letter is added to the searched text,
  /// we give more accurate search results.

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      if (mounted) {
        setState(() {});
      }
      return;
    }

    _contactDetails.forEach((contact) {
      if (contact.firstName.contains(text)) _searchResult.add(contact);
    });
    _contactDetails.sort((a, b) => a.firstName.compareTo(b.firstName));
    if (mounted) {
      setState(() {});
    }
  }

  //Here we create the widget symbolizing files, by using query results from
  //the data base.

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
              title: new Text(
                  contacts[index].firstName + ' ' + contacts[index].lastName),
              subtitle: new Text(contacts[index].field),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => edit_contact_page.EditContactPage(
                            contact: contacts[index],
                            displayEdit:
                                true))).then((value) => getUserDetails());
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
