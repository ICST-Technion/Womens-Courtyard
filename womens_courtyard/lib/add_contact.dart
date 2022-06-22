import 'package:flutter/material.dart';
import 'package:womens_courtyard/personal_file.dart';

class AddContactPage extends StatefulWidget {
  AddContactPage({Key? key, this.title = ''}) : super(key: key);

  final String title;
  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  List<String> _categories = [
    'עו"ס רווחה',
    'פסיכיאטר/ מרפאה בריאות הנפש',
    'סל שיקום',
    'עמותות מסייעות',
    'חינוך',
    'הורים'
  ];
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
    final privateNameField = TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: firstNameTextController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'הכניסי שם פרטי';
          }
          return null;
        },
        onSaved: (value) {
          firstNameTextController.text = value ?? '';
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'שם פרטי',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final lastNameField = TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: lastNameTextController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'הכניסי שם משפחה';
          }
          return null;
        },
        onSaved: (value) {
          lastNameTextController.text = value ?? '';
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'שם משפחה',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final emailField = TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: emailTextController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email_sharp),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'אימייל',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final phoneNumberField = TextFormField(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: phoneNumberTextController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'הכניסי מספר טלפון';
          }
          //regExp
          RegExp passReg = new RegExp(r'^(?:[+0]9)?[0-9]{10}$');
          if (!passReg.hasMatch(value)) {
            return 'הכניסי מספר טלפון חוקי';
          }
          return null;
        },
        onSaved: (value) {
          phoneNumberTextController.text = value ?? '';
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'מספר טלפון',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: getHomepageAppBar(),
        body: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(15.0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'הוספת איש/ת קשר',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: privateNameField,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Flexible(child: lastNameField),
                  ],
                ),
                SizedBox(
                  width: 20.0,
                ),
                phoneNumberField,
                SizedBox(
                  width: 20.0,
                ),
                emailField,
                SizedBox(
                  width: 20.0,
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
                      child: Text('סיום ושמירה'),
                      onPressed: () {
                        if (_formKey.currentState != null &&
                            (_formKey.currentState!).validate()) {
                          addContactToDatabase(
                              firstNameTextController.text,
                              lastNameTextController.text,
                              phoneNumberTextController.text,
                              emailTextController.text,
                              _selectedCategory ?? 'לא מוגדר');
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
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
    return AppBar(title: Text('הוספת איש/ת קשר'), actions: [
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
    // DatabaseReference ref = FirebaseDatabase.instance.ref('clients/$idNo');
    putContact({
      'firstName': firstName,
      'lastName': lastName,
      'field': field,
      'phoneNo': phone,
      'email': email,
      'info': ""
    })
        .then((_) => print('added contact'))
        .catchError((e) => print('update failed $e'));
  }
}
