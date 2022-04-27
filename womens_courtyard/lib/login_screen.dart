import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:womens_courtyard/main.dart';
import 'register_screen.dart' as registration_screen;
import 'BottomNavigationBar.dart' as bottom_navigation_bar;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:crypto/crypto.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();
  // firebase instances
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  //controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "הכניסי את כתובת המייל שלך";
          }

          //reg expression for validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return "הכניסי כתובת טקסט תקינה";
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "מייל",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final passField = TextFormField(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: passController,
        obscureText: true,
        validator: (value) {
          RegExp passReg = new RegExp(r'^.{6,}$');
          if (value == null || value.isEmpty) {
            return "הכניסי את הסיסמה שלך";
          }
          if (!passReg.hasMatch(value)) {
            return "על אורך הסיסמה להיות 6 תווים לפחות";
          }
          return null;
        },
        onSaved: (value) {
          passController.text = value;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "סיסמה",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.purpleAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (_formKey.currentState != null &&
              _formKey.currentState.validate()) {
            loginUser(emailController.text, passController.text);
          }
        },
        child: Text("כניסה",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
      ),
    );

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.purple,
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // SizedBox(
                        //   height: 200,
                        //   child: Image.asset(name, fit: BoxFit.contain, )
                        // ),
                        SizedBox(height: 45),
                        emailField,
                        SizedBox(height: 25),
                        passField,
                        SizedBox(height: 35),
                        loginButton,
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("הוספת משתמשת צוות (אפשרות זמנית): "),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              registration_screen
                                                  .RegistrationScreen()));
                                },
                                child: Text("הירשמי",
                                    style: TextStyle(
                                        color: Colors.purpleAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void loginUser(String username, String password) async {
    //Call token generator
    HttpsCallable callable = functions.httpsCallable('generateToken');
    var passbytes = utf8.encode(password);
    var passhash = sha256.convert(passbytes).toString();
    final results = await callable
        .call(<String, dynamic>{'username': username, 'password': passhash});

    bool success = results.data['success'];
    print('token request returned with status $success');
    if (!success) {
      showDialog(
          context: context,
          builder: (context) {
            return Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                    title: Text('ניסיון התחברות שגוי'),
                    content: Text('בבקשה נסי שוב'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Text('הבנתי'),
                      )
                    ]));
          });
    } else {
      final role = results?.data['data']['role'];
      final token = results?.data['data']['token'];
      auth.signInWithCustomToken(token);
      if (role == 'staff') {
        print('logging in as staff');
        // var id = results.data['data']['id'];
        print('the name is $username');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    bottom_navigation_bar.MyBottomNavigationBar(
                        username: username)));
      } else if (role == 'client') {
        print('logging in as client');
        //TODO: enter client main page
      }
    }
  }
}
