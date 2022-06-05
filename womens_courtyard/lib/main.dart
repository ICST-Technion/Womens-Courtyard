// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:womens_courtyard/firebase_options.dart';
import 'dart:async';
import 'login_screen.dart' as login_screen;
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:io' show Platform;

/// This file is in charge of connecting to the firebase emulator.
/// When starting the app, this file is called, and it handles the start of the
/// app and navigates the user to the login page.

const bool USE_EMULATOR = false;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

/* Connect to the firebase emulator ports.
*/
Future _connectToFirebaseEmulator() async {
  final localHostString = 'localhost';

  FirebaseFirestore.instance.settings = Settings(
    host: '$localHostString:8080',
    sslEnabled: false,
    persistenceEnabled: false,
  );
  FirebaseFirestore.instance.useFirestoreEmulator(localHostString, 8080);

  final _functions = FirebaseFunctions.instance;
  _functions.useFunctionsEmulator(localHostString, 5001);
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initiallization =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initiallization,
      builder: (context, snapshot) {
        // The snapshot describes the state of the future - the firebase connection.
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text(snapshot.error.toString(),
                      textDirection: TextDirection.ltr)));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (USE_EMULATOR) {
      _connectToFirebaseEmulator();
    }
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: login_screen.LoginScreen(),
    );
  }
}
