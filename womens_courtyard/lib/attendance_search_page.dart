import 'dart:async';
import 'package:flutter/material.dart';
import 'package:womens_courtyard/personal_file.dart';
import 'package:womens_courtyard/attendance_page.dart' as attendance_page;

/// This page is in charge of searching certain parameters and women in the
/// attendance forms.
/// For a certain user, this page is able to trace the details of the user's
/// attendance from the firebase.

class AttendanceSearchPage extends StatefulWidget {
  AttendanceSearchPage({Key? key}) : super(key: key);

  @override
  AttendanceSearchPageState createState() => new AttendanceSearchPageState();
}

/// The main class that's in charge of the state of each field needed for the
/// page and the design in the app.

class AttendanceSearchPageState extends State<AttendanceSearchPage> {
  TextEditingController controller = new TextEditingController();

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    try {
      _personalFiles = [];
      final response = await getPersonalFileDocs();
      _personalFiles = [];
      for (final doc in response) {
        _personalFiles.add(PersonalFile.fromDoc(doc));
      }
      _personalFiles.sort((a, b) => a.firstName.compareTo(b.firstName));
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
    // This method is rerun every time there's a certain change in the state
    // of the program., and builds the design of the page.

    return Directionality(
      textDirection: TextDirection.rtl,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('הזנת נוכחות'),
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
                  "מסך חיפוש ועדכון נוכחות, כאן תוכלי ללחוץ על הצעירה המתאימה ואז להזין לה נוכחות",
            )
          ],
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
                    : FileList(list: _personalFiles)),
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
      setState(() {});
      return;
    }
    //Getting all personal files containing the written subtext in the searchbar.
    _personalFiles.forEach((personalFile) {
      if (personalFile.idNo.toString().contains(text) ||
          personalFile.firstName.contains(text) ||
          personalFile.lastName.contains(text) ||
          (personalFile.firstName + ' ' + personalFile.lastName).contains(text))
        _searchResult.add(personalFile);
    });

    // Sorting them for a comfortable display.
    _personalFiles.sort((a, b) => a.firstName.compareTo(b.firstName));

    setState(() {});
  }
}

/// A class in charge of building the file list showing the structure of the
/// files suggested using the text search.

class FileList extends StatelessWidget {
  final List<PersonalFile> list;
  FileList({required this.list});

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
                          attendance_page.AttendancePage(file: list[index])));
            },
            leading: Icon(Icons.folder),
            title: new Text(list[index].firstName + ' ' + list[index].lastName),
            subtitle: new Text('תעודת זהות: ' + list[index].idNo.toString()),
          ),
          margin: const EdgeInsets.all(0.0),
        );
      },
    );
  }
}

List<PersonalFile> _searchResult = [];

List<PersonalFile> _personalFiles = [];
