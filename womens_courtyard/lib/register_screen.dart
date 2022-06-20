import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:crypto/crypto.dart';
import 'package:womens_courtyard/bottom_navigation_bar.dart'
    as bottom_navigation_bar;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final RegisterHandle registerHandle = RegisterHandle(
      registerFunctionHandle:
          RegisterFunctionHandle(functions: FirebaseFunctions.instance));
  //our form key
  final _formKey = GlobalKey<FormState>();
  //editing controller
  final fullnameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passEditingController = new TextEditingController();
  final confirmPassEditingController = new TextEditingController();

  List<String> branchOptions = ['חיפה', 'נתניה', 'יפו', 'מטה'];
  String branch = 'חיפה';

  @override
  Widget build(BuildContext context) {
    //full name field
    final fullNameField = TextFormField(
        autofocus: false,
        controller: fullnameEditingController,
        keyboardType: TextInputType.name,
        //validator: () {},
        onSaved: (value) {
          fullnameEditingController.text = value ?? '';
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.face),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'שם מלא',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'הכניסי את כתובת המייל שלך';
          }

          //reg expression for validation
          if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]')
              .hasMatch(value)) {
            return 'הכניסי כתובת מייל תקינה';
          }
          return null;
        },
        onSaved: (value) {
          emailEditingController.text = value ?? '';
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

    final branchField = Row(children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          'סניף:',
          style: TextStyle(fontSize: 16),
        ),
      ),
      DropdownButton(
        // Initial Value
        value: branch,

        // Down Arrow Icon
        icon: const Icon(Icons.keyboard_arrow_down),

        // Array list of items
        items: branchOptions.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        // After selecting the desired option,it will
        // change button value to selected value
        onChanged: (String? newValue) {
          setState(() {
            branch = newValue!;
          });
        },
      )
    ]);

    //password field
    final passField = TextFormField(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: passEditingController,
        obscureText: true,
        validator: (value) {
          RegExp passReg = new RegExp(r'^.{6,}$');
          if (value == null || value.isEmpty) {
            return 'הכניסי את הסיסמה שלך';
          }
          if (!passReg.hasMatch(value)) {
            return 'על אורך הסיסמה להיות לפחות 6 תווים';
          }
          return null;
        },
        onSaved: (value) {
          passEditingController.text = value ?? '';
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'סיסמה',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //confirm password field
    final confirmPassField = TextFormField(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
        autofocus: false,
        controller: confirmPassEditingController,
        obscureText: true,
        validator: (value) {
          if (confirmPassEditingController.text != passEditingController.text) {
            return 'אישור הסיסמה לא תואם את הסיסמה המקורית';
          }
          return null;
        },
        onSaved: (value) {
          confirmPassEditingController.text = value ?? '';
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'אישור הסיסמה',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.purpleAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () async {
          if (_formKey.currentState != null &&
              (_formKey.currentState!).validate()) {
            bool res = await this.registerHandle.register(
                emailEditingController.text,
                passEditingController.text,
                fullnameEditingController.text,
                branch);
            if (res) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          bottom_navigation_bar.MyBottomNavigationBar()));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('כניסה מוצלחת')),
              );
            } else {
              throw FirebaseAuthException(
                  message: 'something went horribly wrong', code: '-1');
            }
          }
        },
        child: Text('להרשמה',
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
          appBar: AppBar(
            title: new Text('הוספת חברת צוות'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  // passing this to our root
                  Navigator.of(context).pop();
                }),
          ),
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
                        fullNameField,
                        SizedBox(height: 25),
                        emailField,
                        SizedBox(height: 20),
                        branchField,
                        SizedBox(height: 20),
                        passField,
                        SizedBox(height: 25),
                        confirmPassField,
                        SizedBox(height: 15),
                        signUpButton,
                        SizedBox(height: 20),
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

class RegisterFunctionHandle {
  final FirebaseFunctions functions;

  RegisterFunctionHandle({required this.functions});

  dynamic getRegisterResult(
      String username, String password, String name, String branch,
      {String role = 'staff'}) async {
    var passbytes = utf8.encode(password);
    var passhash = sha256.convert(passbytes).toString();
    HttpsCallable callable = functions.httpsCallable('registerClient');
    final results = await callable.call(<String, dynamic>{
      'username': username,
      'name': name,
      'password': passhash,
      'branch': branch,
      'role': role
    });
    return results;
  }
}

class RegisterHandle {
  final RegisterFunctionHandle registerFunctionHandle;

  RegisterHandle({required this.registerFunctionHandle});

  Future<bool> register(
      String username, String password, String name, String branch,
      {String role = 'staff'}) async {
    var results = await this
        .registerFunctionHandle
        .getRegisterResult(username, password, name, branch);
    bool success = results.data['success'];
    if (!success) {
      print('NEVER EVER SHOULD GET HERE');
      return false;
    } else {
      print(results.data['success'].toString());
      return true;
    }
  }
}
