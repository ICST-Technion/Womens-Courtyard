import 'package:flutter/material.dart';
import 'addContact.dart' as add_contact_page;
import 'BottomNavigationBar.dart' as bottom_navigation_bar;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      home: MyHomePage(title: 'מסך הזנת תיק אישי'),
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
  //form key
  final _formKey = GlobalKey<FormState>();
  // firebase instances
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  //controller
  final TextEditingController nameTextController = new TextEditingController();
  final TextEditingController fNameTextController = new TextEditingController();
  final TextEditingController tazTextController = new TextEditingController();
  final TextEditingController phoneNumberTextController =
      new TextEditingController();
  final TextEditingController processDescriptionTextController =
      new TextEditingController();

  @override
  void dispose() {
    nameTextController.dispose();
    fNameTextController.dispose();
    tazTextController.dispose();
    phoneNumberTextController.dispose();
    processDescriptionTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final privateNameField = TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: nameTextController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "הכניסי שם פרטי";
          }
          return null;
        },
        onSaved: (value) {
          nameTextController.text = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "שם פרטי",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final fNameField = TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: fNameTextController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "הכניסי שם משפחה";
          }
          return null;
        },
        onSaved: (value) {
          fNameTextController.text = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "שם משפחה",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final tazField = TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: tazTextController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "הכניסי תעודת זהות";
          }
          //regExp
          RegExp passReg = new RegExp(r'^[0-9]{9}$');
          if (!passReg.hasMatch(value)) {
            return "על התז להיות חוקי (9 ספרות)";
          }
          return null;
        },
        onSaved: (value) {
          tazTextController.text = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "תעודת זהות",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final phoneNumberField = TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: phoneNumberTextController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "הכניסי מספר פאלפון";
          }
          //regExp
          RegExp passReg = new RegExp(r'^(?:[+0]9)?[0-9]{10}$');
          if (!passReg.hasMatch(value)) {
            return "הכניסי טלפון חוקי";
          }
          return null;
        },
        onSaved: (value) {
          phoneNumberTextController.text = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "מספר פאלפון",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final proccessDescriptionField = TextFormField(
        minLines: 1,
        maxLines: 10,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: processDescriptionTextController,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          processDescriptionTextController.text = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "תיאור טיפול",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: getHomepageAppBar(),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(15.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'תיק טיפול',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(child: privateNameField),
                  SizedBox(
                    width: 20.0,
                  ),
                  Flexible(child: fNameField),
                ],
              ),
              SizedBox(
                height: 150,
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Flexible(child: tazField),
                    SizedBox(
                      height: 10.0,
                    ),
                    Flexible(child: phoneNumberField),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'אנשי קשר:',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
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
                        minimumSize: Size(10, 10),
                        textStyle: TextStyle(color: Colors.white, fontSize: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)))),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(blurRadius: 20, spreadRadius: -15)
                      ]),
                  child: proccessDescriptionField),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: ElevatedButton(
                    child: Text("הזנת קבצים חדשים"),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(250, 84, 9, 0),
                        elevation: 4,
                        minimumSize: Size(100, 50),
                        textStyle: TextStyle(color: Colors.white, fontSize: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)))),
              ),
              Padding(
                padding: const EdgeInsets.all(64.0),
                child: ElevatedButton(
                    child: Text("סיום ושמירה"),
                    onPressed: () {
                      //enter the results from the controllers.text into the firebase, then navigate back.
                      // showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return AlertDialog(
                      //       content: Text(nameTextController.text),
                      //     );
                      //   },
                      // );
                      enterFileToDatabase(
                          nameTextController.text,
                          fNameTextController.text,
                          tazTextController.text,
                          phoneNumberTextController.text,
                          processDescriptionTextController.text);
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
    return AppBar(title: Text('הזנת תיק אישי'), actions: [
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

  ListTile getListTile(text, icon, action) {
    return ListTile(
      title: Text(text, style: TextStyle(fontSize: 19, color: Colors.white)),
      trailing: Icon(icon, color: Colors.white),
      onTap: action,
    );
  }

  void enterFileToDatabase(
      String name, String fname, String taz, String phone, String pDec) async {
    // enter actual user into database
    // HttpsCallable callable = functions.httpsCallable('registerClient');
    // final results = await callable.call(<String, dynamic>{
    //   'username': username,
    //   'name': name,
    //   'password': password,
    //   'role': role
    // });
    // print(results.data['success'].toString());
  }
}
