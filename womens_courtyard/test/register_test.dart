import 'package:womens_courtyard/register_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_functions/cloud_functions.dart';

final users = <String, String>{};

//class MockFirebaseFunctions extends Mock implements FirebaseFunctions {}

class Result {
  final dynamic data;

  Result({this.data});
}

class MockRegisterFunctionHandle extends Mock
    implements RegisterFunctionHandle {
  @override
  dynamic getRegisterResult(
      String username, String password, String name, String branch,
      {String role = 'staff'}) async {
    if (users.containsKey(username) || username == 'invalid token') {
      return Result(data: {'success': false});
    } else {
      users[username] = password;
      return Result(data: {'success': true});
    }
  }
}

void main() {
  //final MockFirebaseFunctions mockFunctions = MockFirebaseFunctions();
  final RegisterHandle registerHandle =
      RegisterHandle(registerFunctionHandle: MockRegisterFunctionHandle());
  setUp(() {
    users.clear();
  });
  tearDown(() {
    users.clear();
  });

  test('register succesful basic 1', () async {
    expect(
        await registerHandle.register('hanna', 'sennesh', 'default', 'haifa'),
        true);
    assert(users.containsKey('hanna'));
    assert(users['hanna'] == 'sennesh');
  });

  test('register succesful basic 2', () async {
    expect(
        await registerHandle.register('hanna', 'sennesh', 'default', 'haifa'),
        true);
    expect(
        await registerHandle.register('yosi', 'gil', 'default', 'haifa'), true);
    assert(users.containsKey('hanna'));
    assert(users['hanna'] == 'sennesh');
    assert(users.containsKey('yosi'));
    assert(users['yosi'] == 'gil');
  });

  test('register succesful basic 3', () async {
    expect(
        await registerHandle.register('samira', 'nirvanna', 'default', 'haifa'),
        true);
    expect(
        await registerHandle.register('hanna', 'sennesh', 'default', 'haifa'),
        true);
    expect(
        await registerHandle.register('yosi', 'gil', 'default', 'haifa'), true);
    assert(users.containsKey('hanna'));
    assert(users['hanna'] == 'sennesh');
    assert(users.containsKey('yosi'));
    assert(users['yosi'] == 'gil');
    assert(users.containsKey('samira'));
    assert(users['samira'] == 'nirvanna');
  });

  test('conflicting usernames 1', () async {
    expect(
        await registerHandle.register('hanna', 'sennesh', 'default', 'haifa'),
        true);
    expect(
        await registerHandle.register('hanna', 'nirvanna', 'default', 'haifa'),
        false);
    assert(users.containsKey('hanna'));
    assert(users['hanna'] == 'sennesh');
  });

  test('conflicting usernames 2', () async {
    expect(
        await registerHandle.register('yosi', 'gil', 'default', 'haifa'), true);
    expect(
        await registerHandle.register('yosi', 'gilgilon', 'default', 'haifa'),
        false);
    assert(users.containsKey('yosi'));
    assert(users['yosi'] == 'gil');
  });

  test('conflicting usernames 3', () async {
    expect(
        await registerHandle.register('samira', 'nirvanna', 'default', 'haifa'),
        true);
    expect(
        await registerHandle.register(
            'samira', 'badbadboo', 'default', 'haifa'),
        false);
    assert(users.containsKey('samira'));
    assert(users['samira'] == 'nirvanna');
  });

  test('invalid register 1', () async {
    expect(
        await registerHandle.register(
            'invalid token', 'nirvanna', 'default', 'haifa'),
        false);
    assert(users.isEmpty == true);
  });

  test('invalid register 2', () async {
    expect(
        await registerHandle.register(
            'invalid token', 'nirvanna', 'default', 'haifa'),
        false);
    expect(
        await registerHandle.register('samira', 'nirvanna', 'default', 'haifa'),
        true);
    assert(users.containsKey('samira') == true);
    assert(users.length == 1);
  });

  test('invalid register 3', () async {
    expect(
        await registerHandle.register(
            'invalid token', 'nirvanna', 'default', 'haifa'),
        false);
    expect(
        await registerHandle.register('samira', 'nirvanna', 'default', 'haifa'),
        true);
    expect(
        await registerHandle.register('yosi', 'gil', 'default', 'haifa'), true);
    assert(users.containsKey('samira') == true);
    assert(users.length == 2);
  });

  test('all encapsulating', () async {
    expect(
        await registerHandle.register(
            'invalid token', 'nirvanna', 'default', 'haifa'),
        false);
    expect(
        await registerHandle.register('hanna', 'sennesh', 'default', 'haifa'),
        true);
    expect(await registerHandle.register('hanna', 'gil', 'default', 'haifa'),
        false);
    assert(users.containsKey('hanna') == true);
    assert(users.length == 1);
    assert(users['hanna'] == 'sennesh');
  });
}
