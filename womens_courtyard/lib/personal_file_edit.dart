import 'package:flutter/material.dart';
import 'main.dart' as main_page;
import 'contact.dart' as contact;
import 'contacts_data.dart' as contacts_data;
import 'personal_file.dart';
import 'forms_buttons.dart' as forms;
import 'BottomNavigationBar.dart' as bottom_navigation_bar;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'מסך איש קשר'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, @required this.person}) : super(key: key);

  final PersonalFile person;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    var curr_contact = contacts_data.allContacts[0];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: getHomepageAppBar(),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(15.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    widget.person.name,
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    widget.person.id.toString(),
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                    initialValue: widget.person.info,
                    minLines: 1,
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'מידע נוסף',
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: ElevatedButton(
                    child: Text("מעבר לטפסים"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => forms.MyHomePage()));
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(250, 84, 9, 0),
                        elevation: 4,
                        minimumSize: Size(100, 50),
                        textStyle: TextStyle(color: Colors.white, fontSize: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)))),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    child: Text("לעריכה"),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(250, 84, 9, 0),
                        elevation: 4,
                        minimumSize: Size(100, 50),
                        textStyle: TextStyle(color: Colors.white, fontSize: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)))),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: ElevatedButton(
                    child: Text("סיום ושמירה"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => bottom_navigation_bar
                                  .MyBottomNavigationBar()));
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(250, 84, 9, 0),
                        elevation: 4,
                        minimumSize: Size(150, 50),
                        textStyle: TextStyle(color: Colors.white, fontSize: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar getHomepageAppBar() {
    return AppBar(title: Text('הזנת נוכחות'), actions: [
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
