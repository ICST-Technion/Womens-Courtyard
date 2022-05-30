import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter_test/flutter_test.dart' as ft;
import 'package:test/test.dart';
import 'package:womens_courtyard/firebase_options.dart';
import 'package:womens_courtyard/login_screen.dart' as ls;
// import 'package:womens_courtyard/main.dart' as mainPage;

void main() {
  group('Login', () {
    test('Hanna should login successfully', () async {
      print("AAAAAAAAAAA");
      WidgetsFlutterBinding.ensureInitialized();

      print("AAAAAAAAAAA");
      await Firebase.initializeApp();
      print("AAAAAAAAAAA");
      print("AAAAAAAAAAA");
      var results = await ls.tryLogin("hanna@gmail.com", 'sennesh');

      print("AAAAAAAAAAA");
      expect(results.data['success'], true);
      print("AAAAAAAAAAA");
      expect(true, true);
    });
  });
}
