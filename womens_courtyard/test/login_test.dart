// @dart=2.9
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:womens_courtyard/login_screen.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Future<UserCredential> signInWithCustomToken(String token) {
    if (token == 'test_token') {
      return null;
    }
    throw FirebaseAuthException(message: 'unexpected token', code: '111');
  }
}

class Result {
  final dynamic data;

  Result({this.data});
}

class MockDynamicHandler extends Mock implements DynamicLoginHandler {
  //MockDynamicHandler(MockFirebaseFunctions mockFunctions);

  @override
  dynamic get_login_result(String username, String password) async {
    if ((username == 'hanna' && password == 'sennesh') ||
        (username == 'yosi' && password == 'gil') ||
        (username == 'samira' && password == 'nirvanna')) {
      return Result(data: {
        'success': true,
        'data': {
          'role': 'staff',
          'token': 'test_token',
          'username': 'username',
          'branch': 'haifa'
        }
      });
    } else if ((username == 'hanna' && password != 'sennesh') ||
        (username == 'yosi' && password != 'gil') ||
        (username == 'samira' && password != 'nirvanna')) {
      return Result(data: {'success': false, 'data': 'wrong password'});
    } else if (username == 'not-hanna' ||
        username == 'not-yosi' ||
        username == 'not-samira') {
      return Result(data: {
        'success': false,
        'data': 'username $username does not exist'
      });
    } else if (username == 'token_error1' ||
        username == 'token_error2' ||
        username == 'token_error3') {
      return Result(data: {
        'success': true,
        'data': {
          'role': 'staff',
          'token': 'miss_fire',
          'username': 'hanna',
          'branch': 'haifa'
        }
      });
    }
  }
}

class MockFirebaseFunctions extends Mock implements FirebaseFunctions {
  // @override
  // HttpsCallable httpsCallable(String name, {HttpsCallableOptions options}) {
  //   return null;
  //   return ({String username, dynamic password}) {
  //     return {
  //       'success': true,
  //       'data': {
  //         'role': 'staff',
  //         'token': 'test_token',
  //         'username': 'hanna',
  //         'branch': 'haifa'
  //       }
  //     };
  //   } as HttpsCallable;
  // }
}

void main() {
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  //final MockFirebaseFunctions mockFunctions = MockFirebaseFunctions();
  final MockDynamicHandler mockDynamicHandler = MockDynamicHandler();

  final LoginHandler loginHandler =
      LoginHandler(auth: mockFirebaseAuth, dynamicHandler: mockDynamicHandler);
  test('login test successful 1', () async {
    expect(await loginHandler.loginUser('hanna', 'sennesh'), true);
  });

  test('login test successful 2', () async {
    expect(await loginHandler.loginUser('yosi', 'gil'), true);
  });

  test('login test successful 3', () async {
    expect(await loginHandler.loginUser('samira', 'nirvanna'), true);
  });

  test('login test non-existing user 1', () async {
    expect(await loginHandler.loginUser('not-hanna', 'sennesh'), false);
  });

  test('login test non-existing user 2', () async {
    expect(await loginHandler.loginUser('not-yosi', 'gil'), false);
  });

  test('login test non-existing user 3', () async {
    expect(await loginHandler.loginUser('not-samira', 'nirvanna'), false);
  });

  test('login test wrong pass 1', () async {
    expect(await loginHandler.loginUser('hanna', 'wrong'), false);
  });

  test('login test wrong pass 2', () async {
    expect(await loginHandler.loginUser('yosi', 'wrong'), false);
  });

  test('login test wrong pass 3', () async {
    expect(await loginHandler.loginUser('samira', 'wrong'), false);
  });

  test('login token error 1', () async {
    expect(() async => await loginHandler.loginUser('token_error1', 'dummy'),
        throwsA(isA<FirebaseAuthException>()));
  });

  test('login token error 2', () async {
    expect(() async => await loginHandler.loginUser('token_error2', 'dummy'),
        throwsA(isA<FirebaseAuthException>()));
  });

  test('login token error 3', () async {
    expect(() async => await loginHandler.loginUser('token_error3', 'dummy'),
        throwsA(isA<FirebaseAuthException>()));
  });
}
