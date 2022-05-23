import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_test/flutter_test.dart' as ft;
import 'package:test/test.dart';
import 'package:womens_courtyard/firebase_options.dart';
import 'package:womens_courtyard/login_screen.dart';
import 'package:womens_courtyard/main.dart' as mainPage;

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized();
  print('1111');
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('1111');
  group('Login', () {
    test('Hanna should login successfully', () async {
      print("AAAAAAAAAAA");
      var screen = LoginScreen().createState();
      var results = await screen.tryLogin("hanna@gmail.com", 'sennesh');
      expect(results.data['success'], true);
    });

    test('Non-existent email logged in successfully', () async {
      var screen = LoginScreen().createState();
      var results = await screen.tryLogin("test@gmail.com", 'sennesh');
      expect(results.data['success'], false);
    });

    test('Wrong password logged in successfully', () async {
      var screen = LoginScreen().createState();
      var results = await screen.tryLogin("hanna@gmail.com", 'bad_pass');
      expect(results.data['success'], false);
    });
  });
}
