// @dart=2.9
import 'package:flutter_test/flutter_test.dart';
import 'package:womens_courtyard/login_screen.dart';

void main() {
  final logInUser mockLogIn = logInUser();
  test('login test', () async {
    expect(mockLogIn.loginUser('hana@gmail.com', 'sennesh'), true);
  });
}
