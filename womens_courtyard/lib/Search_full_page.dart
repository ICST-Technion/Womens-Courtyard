import 'package:flutter/material.dart';
import 'search_page.dart' as search_page;

class SearchFullPage extends StatefulWidget {
  SearchFullPage({Key? key, this.title = ""}) : super(key: key);

  final String title;

  @override
  _SearchFullPageState createState() => _SearchFullPageState();
}

class _SearchFullPageState extends State<SearchFullPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: getHomepageAppBar(),
        body: Center(
          child: TextField(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => search_page.SearchPage()));
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'חיפוש...',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {},
                  ))),
        ),
      ),
    );
  }

  AppBar getHomepageAppBar() {
    return AppBar(title: Text('הזנת נוכחות יומית'), actions: [
      IconButton(
        icon: Icon(
          Icons.account_circle,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(
          Icons.info,
          size: 30,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
    ]);
  }
}
