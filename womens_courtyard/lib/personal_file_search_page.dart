import 'dart:async';
import 'package:flutter/material.dart';
import 'package:womens_courtyard/personal_file.dart';
import 'package:womens_courtyard/view_personal_file.dart' as edit_personal_page;
import 'package:cloud_firestore/cloud_firestore.dart';

/// A file in charge of searching a personal file.
/// While searching, the app helps with suggestions of personal files that match
/// the current text in the search bar.
/// When a suggestion is pressed, it leads the user to the personal file
/// selected.

class PersonalFileSearchPage extends StatefulWidget {
  PersonalFileSearchPage({Key? key}) : super(key: key);

  @override
  _PersonalFileSearchPageState createState() =>
      new _PersonalFileSearchPageState();
}

class _PersonalFileSearchPageState extends State<PersonalFileSearchPage> {
  TextEditingController controller = new TextEditingController();

  // Get json result and convert it to model. Then add to the list.
  Future<Null> getUserDetails() async {
    try {
      _personalFiles = [];
      final response = await getPersonalFileDocs();
      _personalFiles = [];
      for (final doc in response) {
        _personalFiles.add(PersonalFile.fromDoc(doc));
      }
      _personalFiles.sort((a, b) => a.firstName.compareTo(b.firstName));
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
        appBar: new AppBar(title: Text('חיפוש תיק אישי')),
        body: new Column(
          children: <Widget>[
            new Container(
              color: Theme.of(context).primaryColor,
              child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Card(
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
            new Expanded(
                child: _searchResult.length != 0 || controller.text.isNotEmpty
                    ? createPersonalFile(_searchResult)
                    : createPersonalFile(_personalFiles)),
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

    _personalFiles.forEach((personalFile) {
      if (personalFile.idNo.toString().contains(text) ||
          personalFile.firstName.contains(text) ||
          personalFile.lastName.contains(text) ||
          (personalFile.firstName + ' ' + personalFile.lastName).contains(text))
        _searchResult.add(personalFile);
    });
    _personalFiles.sort((a, b) => a.firstName.compareTo(b.firstName));
    if (mounted) {
      setState(() {});
    }
  }

  // We create and get the personal files in the following functions.

  Container createPersonalFile(List<PersonalFile> personalList) {
    return Container(
      height: 750,
      child: new ListView.builder(
        // Search query results
        itemCount: personalList.length,
        itemBuilder: (context, index) {
          return new Card(
            child: new ListTile(
              leading: Icon(Icons.contact_page),
              title: new Text(personalList[index].firstName +
                  " " +
                  personalList[index].lastName),
              subtitle: new Text(personalList[index].idNo.toString()),
              onTap: () async {
                List<ContactFile> myContacts =
                    await getContactList(personalList[index].contactKeys);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            edit_personal_page.PersonalFileEditPage(
                                person: personalList[index],
                                contacts: myContacts))).then((value) async =>
                    {await getUserDetails(), print("got here!")});
              },
            ),
            margin: const EdgeInsets.all(0.0),
          );
        },
      ),
    );
  }

  Future<List<ContactFile>> getContactList(List<String> contactKeys) async {
    List<ContactFile> result = [];
    var contactsCollection = getContactsCollection();
    for (String key in contactKeys) {
      var currDoc = await contactsCollection.doc(key).get();
      result.add(ContactFile.fromDocNoQuery(currDoc as DocumentSnapshot<Map>));
    }
    return result;
  }
}

List<PersonalFile> _searchResult = [];

List<PersonalFile> _personalFiles = [];
