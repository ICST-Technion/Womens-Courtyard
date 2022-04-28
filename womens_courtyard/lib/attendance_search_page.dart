import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'attendance_page.dart' as attendance_page;

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

class SearchPage extends StatelessWidget {
  Future<List<Post>> search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    return List.generate(1, (int index) {
      return Post(
        "שם פרטי : $search",
        "שם משפחה : ישראלי",
      );
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
              hintText: "חיפוש",
              onSearch: search,
              onItemFound: (Post post, int index) {
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.description),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                attendance_page.AttendancePage()));
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
