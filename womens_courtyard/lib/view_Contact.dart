import 'package:flutter/material.dart';
import 'Search_page.dart' as search_page;
import 'addContact.dart' as add_contact_page;
import 'searchContact.dart' as search_contact;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title = ""}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(blurRadius: 20, spreadRadius: -15)]),
        child: TextField(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => search_contact.HomePage()));
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'חיפוש איש קשר...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {},
                ))));
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: getHomepageAppBar(),
        body: Column(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
            ),
            SearchWidget(),
            Padding(
              padding: const EdgeInsets.all(15.0),
            ),
            Padding(
              padding: const EdgeInsets.all(64.0),
              child: ElevatedButton(
                  child: Text("הוספת איש קשר"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => add_contact_page.MyApp()));
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(250, 84, 9, 0),
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

  AppBar getHomepageAppBar() {
    return AppBar(title: Text('צפייה באיש קשר'), actions: [
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
