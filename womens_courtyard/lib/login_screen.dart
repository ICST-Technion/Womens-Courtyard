import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:womens_courtyard/main.dart';
import 'register_screen.dart' as registration_screen;
import 'bottom_navigation_bar.dart' as bottom_navigation_bar;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:crypto/crypto.dart';

/// Main app login screen.
/// The login works directly in parallel with the databsae, and confirms the
/// logging in with it.
/// The page also makes sure the login details are valid, and only then tries
/// to login.
/// Notice that this page is only for login, a regular user can't perform a
/// registration on her own, and only a meta user needs to register the girls.

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'הכניסי את כתובת המייל שלך';
          }

          //reg expression for validation
          if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
              .hasMatch(value)) {
            return 'הכניסי כתובת טקסט תקינה';
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value ?? '';
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'מייל',
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
            return 'הכניסי את הסיסמה שלך';
          }
          if (!passReg.hasMatch(value)) {
            return 'על אורך הסיסמה להיות 6 תווים לפחות';
          }
          return null;
        },
        onSaved: (value) {
          passController.text = value ?? '';
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'סיסמה',
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
        onPressed: () async {
          if (_formKey.currentState != null &&
              _formKey.currentState!.validate()) {
            showLoaderDialog(context);
            bool res =
                await loginUser(emailController.text, passController.text);
            if (!res) {
              Navigator.of(context, rootNavigator: true).pop();
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
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                child: Text('הבנתי'),
                              )
                            ]));
                  });
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          bottom_navigation_bar.MyBottomNavigationBar(
                              username: emailController.text)));
            }
          }
        },
        child: Text('כניסה',
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
          appBar: new AppBar(
            title: new Padding(
                padding: EdgeInsets.all(100), child: Text('התחברות')),
            titleSpacing: 100,
            elevation: 0.0,
          ),
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: <Widget>[
                        //     Text('הוספת משתמשת צוות (אפשרות זמנית): '),
                        //     GestureDetector(
                        //         onTap: () {
                        //           Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                   builder: (context) =>
                        //                       registration_screen
                        //                           .RegistrationScreen()));
                        //         },
                        //         child: Text('הירשמי',
                        //             style: TextStyle(
                        //                 color: Colors.purpleAccent,
                        //                 fontWeight: FontWeight.bold,
                        //                 fontSize: 15))),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }


  /// Here we deal with the login in terms of the database, we do it by encoding
  /// the password, sending the regular username, and see whether there's a fit
  /// in the system.
  /// We recognize if the person trying to sign in is a worker or not, and print
  /// a suitable message, and also go into the part of the app suitable for the
  /// role of the user trying to sign in.

  Future<bool> loginUser(String username, String password) async {
    //Call token generator
    HttpsCallable callable = functions.httpsCallable('generateToken');
    var passbytes = utf8.encode(password);
    var passhash = sha256.convert(passbytes).toString();
    final results = await callable
        .call(<String, dynamic>{'username': username, 'password': passhash});

    bool success = results.data['success'];
    print('token request returned with status $success');
    if (!success) {
      return false;
    } else {
      final role = results.data['data']['role'];
      final token = results.data['data']['token'];
      await auth.signInWithCustomToken(token);
      if (role == 'staff') {
        print('logging in as staff');
        // var id = results.data['data']['id'];
        print('the name is $username');
        return true;
      } else if (role == 'client') {
        print('logging in as client');
        //TODO: enter client main page
      }
      return false;
    }
  }
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(
          margin: EdgeInsets.only(left: 70),
          child: Directionality(
              textDirection: TextDirection.rtl,
              child: Text('מתחבר...', style: TextStyle(fontSize: 12))),
        ),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
