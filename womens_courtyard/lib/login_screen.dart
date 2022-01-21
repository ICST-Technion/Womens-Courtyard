import 'package:flutter/material.dart';
import 'register_screen.dart' as registration_screen;
import 'BottomNavigationBar.dart' as bottom_navigation_bar;
import 'package:cloud_functions/cloud_functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();
  // firebase functions
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  //controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter your email address";
          }

          //reg expression for validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return "Please enter a vaild email address";
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
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final passField = TextFormField(
        autofocus: false,
        controller: passController,
        obscureText: true,
        validator: (value) {
          RegExp passReg = new RegExp(r'^.{6,}$');
          if (value == null || value.isEmpty) {
            return "Please enter your password";
          }
          if (!passReg.hasMatch(value)) {
            return "Password has to be at least 6 length";
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
          hintText: "Password",
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
            //TODO: call login function
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        bottom_navigation_bar.MyBottomNavigationBar()));
          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
      ),
    );

    return Scaffold(
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
                        Text("Don't have an Account? "),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => registration_screen
                                          .RegistrationScreen()));
                            },
                            child: Text("SignUp",
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
    );
  }

  void loginUser(String username, String password) async {
    //Call token generator
    HttpsCallable callable = functions.httpsCallable('generateToken');
    final results = await callable
        .call(<String, dynamic>{'username': username, 'password': password});

    // bool success = results.data['success'];
  }
}