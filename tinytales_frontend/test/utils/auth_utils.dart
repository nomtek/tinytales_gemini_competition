import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/auth/auth_service.dart';

final mockUser = MockUser(uid: 'mock-uid');

class FakeAuthService extends Fake implements AuthService {
  FakeAuthService({
    required this.loginResult,
  });

  final LoginResult loginResult;

  @override
  Future<LoginResult> signInWithGoogle() async {
    return loginResult;
  }
}
