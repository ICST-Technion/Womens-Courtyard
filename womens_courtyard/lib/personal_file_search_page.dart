import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:womens_courtyard/personal_file.dart';
import 'package:womens_courtyard/personal_file_data.dart';
import 'personal_file_edit.dart' as edit_personal_page;
// import 'package:http/http.dart' as http;
import 'personal_file_edit.dart' as personal_file_edit;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = new TextEditingController();

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    try {
      final response =
          await FirebaseFirestore.instance.collection('clients').get();
      for (final doc in response.docs) {
        _userDetails.add(PersonalFile.fromDoc(doc));
      }
      setState(() {});
    } catch (e) {
      print('caught $e');
    }

    // final response = await http.get(url);
    // final responseJson = json.decode(response.body);
    // setState(() {
    //   for (Map user in responseJson) {
    //     _userDetails.add(UserDetails.fromJson(user));
    //   }
    // });
    // await Future.delayed(Duration(seconds: 1));
    // setState(() {
    //   _userDetails = [];
    //   for (PersonalFile file in allFiles) {
    //     _userDetails.add(file);
    //   }
    // });
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
          title: new Text('חיפוש תיק אישי'),
          elevation: 0.0,
        ),
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
                    ? FileList(list: _searchResult)
                    : FileList(list: _userDetails)),
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

    _userDetails.forEach((personalFile) {
      if (personalFile.id.toString().contains(text) ||
          personalFile.name.contains(text)) _searchResult.add(personalFile);
    });

    setState(() {});
  }
}

class FileList extends StatelessWidget {
  final List<PersonalFile> list;
  FileList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      // Search query results
      itemCount: list.length,
      itemBuilder: (context, index) {
        return new Card(
          child: new ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          edit_personal_page.MyHomePage(person: list[index])));
            },
            leading: Icon(Icons.folder),
            title: new Text(list[index].name),
            subtitle: new Text("תעודת זהות: " + list[index].id.toString()),
          ),
          margin: const EdgeInsets.all(0.0),
        );
      },
    );
  }
}

List<PersonalFile> _searchResult = [];

List<PersonalFile> _userDetails = [];

final String url = 'https://jsonplaceholder.typicode.com/users';

class UserDetails {
  final int id;
  final String firstName, lastName;

  UserDetails({this.id, this.firstName, this.lastName});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return new UserDetails(
      id: json['id'],
      firstName: json['name'],
      lastName: json['username'],
    );
  }
}
