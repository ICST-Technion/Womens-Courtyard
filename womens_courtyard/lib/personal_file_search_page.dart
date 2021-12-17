import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:womens_courtyard/personal_file.dart';
import 'package:womens_courtyard/personal_file_data.dart';
// import 'package:http/http.dart' as http;

void main() => runApp(new MaterialApp(
      home: new HomePage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = new TextEditingController();

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    // final response = await http.get(url);
    // final responseJson = json.decode(response.body);
    // setState(() {
    //   for (Map user in responseJson) {
    //     _userDetails.add(UserDetails.fromJson(user));
    //   }
    // });

    await Future.delayed(Duration(seconds: 1));
    setState(() {
      for (PersonalFile file in allFiles) {
        _userDetails.add(file);
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Home'),
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
                        hintText: 'Search', border: InputBorder.none),
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
                ? new ListView.builder(
                    // Search query results
                    itemCount: _searchResult.length,
                    itemBuilder: (context, index) {
                      return new Card(
                        child: new ListTile(
                          // leading: new CircleAvatar(
                          //   backgroundImage: new NetworkImage(
                          //     _searchResult[i].profileUrl,
                          //   ),
                          // ),
                          leading: new Text('ICON GOES HERE'),
                          title: new Text(_searchResult[index].name +
                              ': תעודת זהות' +
                              _searchResult[index].id.toString()),
                        ),
                        margin: const EdgeInsets.all(0.0),
                      );
                    },
                  )
                : new ListView.builder(
                    // No search query
                    itemCount: _userDetails.length,
                    itemBuilder: (context, index) {
                      return new Card(
                        child: new ListTile(
                          // leading: new CircleAvatar(
                          //   backgroundImage: new NetworkImage(
                          //     _userDetails[index].profileUrl,
                          //   ),
                          // ),
                          leading: new Text('ICON GOES HERE'),
                          title: new Text(_userDetails[index].name +
                              ': תעודת זהות' +
                              _userDetails[index].id.toString()),
                        ),
                        margin: const EdgeInsets.all(0.0),
                      );
                    },
                  ),
          ),
        ],
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

List<PersonalFile> _searchResult = [];

List<PersonalFile> _userDetails = [];

final String url = 'https://jsonplaceholder.typicode.com/users';

class UserDetails {
  final int id;
  final String firstName, lastName, profileUrl;

  UserDetails(
      {this.id,
      this.firstName,
      this.lastName,
      this.profileUrl =
          'https://i.amz.mshcdn.com/3NbrfEiECotKyhcUhgPJHbrL7zM=/950x534/filters:quality(90)/2014%2F06%2F02%2Fc0%2Fzuckheadsho.a33d0.jpg'});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return new UserDetails(
      id: json['id'],
      firstName: json['name'],
      lastName: json['username'],
    );
  }
}
