import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/auth/auth.dart';
import 'package:tale_ai_frontend/home/home_page.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';

import '../../utils/utils.dart';
import '../test_app.dart';

void main() {
  testWidgets(
    'LoginPage is default page',
    (tester) async {
      await tester.pumpWidget(
        const TestApp(),
      );

      expect(find.byType(LoginPage), findsOneWidget);
    },
  );

  group(
    'LoginPage tests, log in handling ',
    () {
      late StreamController<User?> userStreamController;

      setUp(() {
        userStreamController = StreamController<User?>();
      });

      tearDown(() {
        userStreamController.close();
      });

      testWidgets(
        'When user taps on Google login button '
        'and login is successful, and user is logged in '
        'then user is redirected to home page ',
        (tester) async {
          await tester.pumpWidget(
            TestApp(
              overrides: [
                userStreamProvider.overrideWith(
                  (ref) => userStreamController.stream,
                ),
                authServiceProvider.overrideWith(
                  (ref) => FakeAuthService(
                    loginResult: LoginResult.success,
                  ),
                ),
              ],
            ),
          );

          await tester.tap(find.byType(GoogleLoginButton));
          userStreamController.add(mockUser);

          await tester.pumpAndSettle();

          expect(find.byType(LoginPage), findsNothing);
          expect(find.byType(HomePage), findsOneWidget);
        },
      );

      testWidgets(
        'When user taps on Google login button '
        'and login is not successful, and user is not logged in '
        'then user is not redirected to home page ',
        (tester) async {
          await tester.pumpWidget(
            TestApp(
              overrides: [
                userStreamProvider.overrideWith(
                  (ref) => userStreamController.stream,
                ),
                authServiceProvider.overrideWith(
                  (ref) => FakeAuthService(
                    loginResult: LoginResult.failure,
                  ),
                ),
              ],
            ),
          );

          await tester.tap(find.byType(GoogleLoginButton));
          await tester.pump();
          expect(find.byType(LoginPage), findsOneWidget);
          expect(find.byType(HomePage), findsNothing);
        },
      );
      testWidgets(
        'When user taps on Google login button '
        'and login is not successful, and user is not logged in '
        'snackbar is shown with error message ',
        (tester) async {
          await tester.pumpWidget(
            TestApp(
              overrides: [
                userStreamProvider.overrideWith(
                  (ref) => userStreamController.stream,
                ),
                authServiceProvider.overrideWith(
                  (ref) => FakeAuthService(
                    loginResult: LoginResult.failure,
                  ),
                ),
              ],
            ),
          );

          await tester.tap(find.byType(GoogleLoginButton));
          await tester.pump();

          expect(find.byType(LoginPage), findsOneWidget);
          final loginErrorSnackBarText = lookupAppLocalizations(
            AppLocalizations.supportedLocales.first,
          ).loginError;
          expect(
            find.widgetWithText(SnackBar, loginErrorSnackBarText),
            findsOneWidget,
          );
        },
      );
    },
  );
}
