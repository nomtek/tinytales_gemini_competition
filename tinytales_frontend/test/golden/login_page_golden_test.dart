import 'package:adaptive_test/adaptive_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/auth/auth_state.dart';
import 'package:tale_ai_frontend/auth/login_page.dart';

import '../test_apps/golden_test_app.dart';

void main() {
  testAdaptiveWidgets('Login page', (tester, windowConfig) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isLoggedInProvider.overrideWithValue(false),
        ],
        child: AdaptiveWrapper(
          windowConfig: windowConfig,
          tester: tester,
          child: const GoldenTestApp(
            child: LoginPage(),
          ),
        ),
      ),
    );

    // wait short time for few frames to render due to infinite animation loop
    // pumpAndSettle doesn't work here
    await tester.pump(const Duration(milliseconds: 50));

    await tester.expectGolden<LoginPage>(
      windowConfig,
      waitForImages: false,
    );
  });
}
