import 'package:flutter/material.dart';

class FormsButtonsPage extends StatefulWidget {
  FormsButtonsPage({Key? key, this.title = ''}) : super(key: key);

  final String title;

  @override
  _FormsButtonsPageState createState() => _FormsButtonsPageState();
}

class _FormsButtonsPageState extends State<FormsButtonsPage> {
  var name = 'אנה';
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: getHomepageAppBar(),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(80.0),
                child: ElevatedButton(
                    child: Text('טפסים רפואיים'),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(250, 84, 9, 0),
                        elevation: 4,
                        minimumSize: Size(150, 70),
                        textStyle: TextStyle(color: Colors.white, fontSize: 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)))),
              ),
              Padding(
                padding: const EdgeInsets.all(60.0),
                child: ElevatedButton(
                    child: Text('טפסי מיצוי זכויות'),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(250, 84, 9, 0),
                        elevation: 4,
                        minimumSize: Size(150, 70),
                        textStyle: TextStyle(color: Colors.white, fontSize: 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)))),
              ),
              Padding(
                padding: const EdgeInsets.all(60.0),
                child: ElevatedButton(
                    child: Text('נוכחות אישית'),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(250, 84, 9, 0),
                        elevation: 4,
                        minimumSize: Size(150, 70),
                        textStyle: TextStyle(color: Colors.white, fontSize: 30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar getHomepageAppBar() {
    return AppBar(title: Text('דף הבית'), actions: [
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
