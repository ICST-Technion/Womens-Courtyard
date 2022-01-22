import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'Costumer_entering.dart' as main_page;
import 'BottomNavigationBar.dart' as bottom_navigation_bar;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'מסך הוספת איש קשר'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _categories = ['רווחה', 'משפט', 'רפואה'];
  String _selectedCategory;

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
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(15.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'הוספת איש קשר',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'שם פרטי',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'שם משפחה',
                      ),
                    ),
                  ),
                ],
              ),
              TextField(
                decoration: new InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "מספר טלפון",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              TextFormField(
                decoration: new InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "כתובת מייל",
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => EmailValidator.validate(value)
                    ? null
                    : "הכניסי בבקשה כתובת אימייל חוקית",
              ),
              DropdownButtonFormField(
                decoration: new InputDecoration(
                  border: UnderlineInputBorder(),
                ),
                //hint: Text('בחרי תחום עיסוק'),
                hint: _selectedCategory == null
                    ? Text('בחרי תחום עיסוק')
                    : Text(
                        _selectedCategory,
                        style: TextStyle(color: Colors.purple),
                      ),
                value: _selectedCategory,
                isExpanded: true,
                iconSize: 30.0,
                style: TextStyle(color: Colors.purple),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: new Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(
                    () {
                      _selectedCategory = newValue;
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(64.0),
                child: ElevatedButton(
                    child: Text("סיום ושמירה"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => bottom_navigation_bar.MyBottomNavigationBar()));
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
    return AppBar(title: Text('הוספת איש קשר'), actions: [
      IconButton(
          icon: Icon(
        Icons.account_circle,
        size: 30,
        color: Colors.white,
      )),
      IconButton(
          icon: Icon(
        Icons.info,
        size: 30,
        color: Colors.white,
      )),
    ]);
  }
}
