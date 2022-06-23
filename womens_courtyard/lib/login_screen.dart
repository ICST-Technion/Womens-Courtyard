import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:womens_courtyard/bottom_navigation_bar.dart'
    as bottom_navigation_bar;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'package:womens_courtyard/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();
  final login_user = LoginHandler(
      auth: FirebaseAuth.instance,
      dynamicHandler:
          DynamicLoginHandler(functions: FirebaseFunctions.instance));
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
            bool res = await login_user.loginUser(
                emailController.text, passController.text);
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
                              bottom_navigation_bar.MyBottomNavigationBar()))
                  .then((value) => {
                        Navigator.of(context, rootNavigator: true).pop(),
                        emailController.text = "",
                        passController.text = ""
                      });
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class DynamicLoginHandler {
  final FirebaseFunctions functions;

  DynamicLoginHandler({required this.functions});

  dynamic get_login_result(String username, String password) async {
    HttpsCallable callable = functions.httpsCallable('generateToken');
    var passbytes = utf8.encode(password);
    var passhash = sha256.convert(passbytes).toString();
    final results = await callable
        .call(<String, dynamic>{'username': username, 'password': passhash});
    return results;
  }
}

class LoginHandler {
  // firebase instances
  final FirebaseAuth auth;
  final DynamicLoginHandler dynamicHandler;

  LoginHandler({required this.auth, required this.dynamicHandler});

  Future<bool> loginUser(String username, String password) async {
    //Call token generator
    var results =
        await this.dynamicHandler.get_login_result(username, password);

    bool success = results.data['success'];
    print('token request returned with status $success');
    if (!success) {
      return false;
    } else {
      final role = results.data['data']['role'];
      final token = results.data['data']['token'];
      final name = results.data['data']['username'];
      final branch = results.data['data']['branch'];
      var user = AppUser();
      user.setFields(name, username, branch);
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
