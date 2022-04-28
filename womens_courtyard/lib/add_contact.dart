import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'client_entering.dart' as main_page;
import 'bottom_navigation_bar.dart' as bottom_navigation_bar;

class AddContactPage extends StatefulWidget {
  AddContactPage({Key? key, this.title = "", this.username = ""})
      : super(key: key);

  final String title;
  final String username;

  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  List<String> _categories = ['רווחה', 'משפט', 'רפואה'];
  String? _selectedCategory;
  final _formKey = GlobalKey<FormState>();

  //controller
  final TextEditingController firstNameTextController =
      new TextEditingController();
  final TextEditingController lastNameTextController =
      new TextEditingController();
  final TextEditingController phoneNumberTextController =
      new TextEditingController();
  final TextEditingController emailTextController = new TextEditingController();

  @override
  void dispose() {
    firstNameTextController.dispose();
    lastNameTextController.dispose();
    phoneNumberTextController.dispose();
    emailTextController.dispose();
    super.dispose();
  }

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
        body: Form(
          key: _formKey,
          child: Center(
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
                        controller: firstNameTextController,
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
                        controller: lastNameTextController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'שם משפחה',
                        ),
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: phoneNumberTextController,
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
                  controller: emailTextController,
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
                  hint: _selectedCategory == null
                      ? Text('בחרי תחום עיסוק')
                      : Text(
                          _selectedCategory!,
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
                        _selectedCategory = newValue as String?;
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(64.0),
                  child: ElevatedButton(
                      child: Text("סיום ושמירה"),
                      onPressed: () {
                        if (_formKey.currentState != null &&
                            (_formKey.currentState!).validate()) {
                          addContactToDatabase(
                              firstNameTextController.text,
                              lastNameTextController.text,
                              phoneNumberTextController.text,
                              emailTextController.text,
                              _selectedCategory ?? "לא מוגדר");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => bottom_navigation_bar
                                      .MyBottomNavigationBar(
                                          username: widget.username)));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(250, 84, 9, 0),
                          elevation: 4,
                          minimumSize: Size(150, 50),
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)))),
                ),
              ],
            ),
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

  void addContactToDatabase(String firstName, String lastName, String phone,
      String email, String field) async {
    // DatabaseReference ref = FirebaseDatabase.instance.ref("clients/$idNo");
    CollectionReference ref = FirebaseFirestore.instance.collection('contacts');
    ref
        .add({
          "firstName": firstName,
          "lastName": lastName,
          "phoneNo": phone,
          "email": email,
          "field": field
        })
        .then((_) => print('updated'))
        .catchError((e) => print('update failed $e'));
  }
}
