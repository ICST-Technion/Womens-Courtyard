import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'attendance_page.dart' as attendance_page;
import 'personal_file.dart';

class Post {
  late final String title;
  late final String description;
  final PersonalFile file;

  Post(this.file) {
    this.title = 'שם פרטי: ${file.firstName}';
    this.description = 'שם משפחה: ${file.lastName}';
  }
}

class AttendanceSearchPage extends StatefulWidget {
  AttendanceSearchPage({Key? key, this.title = '', this.username = ''})
      : super(key: key);

  final String title;
  final String username;
  @override
  _AttendanceSearchPageState createState() => new _AttendanceSearchPageState();
}

class _AttendanceSearchPageState extends State<AttendanceSearchPage> {
  TextEditingController controller = new TextEditingController();
  List<PersonalFile> _searchResult = [];
  List<PersonalFile> _personalFiles = [];

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    try {
      final response =
          await FirebaseFirestore.instance.collection('clients').get();
      for (final doc in response.docs) {
        _personalFiles.add(PersonalFile.fromDoc(doc));
      }
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

  Future<List<Post>> onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      return List.empty();
    }

    _personalFiles.forEach((personalFile) {
      if (personalFile.idNo.toString().contains(text) ||
          personalFile.firstName.contains(text) ||
          personalFile.lastName.contains(text)) _searchResult.add(personalFile);
    });

    return List.generate(_searchResult.length, (index) {
      return Post(_searchResult[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SearchBar<Post>(
              hintText: 'חיפוש',
              onSearch: onSearchTextChanged,
              onItemFound: (Post post, int index) {
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.description),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                attendance_page.AttendancePage(
                                    username: widget.username,
                                    file: post.file)));
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
