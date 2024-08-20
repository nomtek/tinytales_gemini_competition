import 'package:adaptive_test/adaptive_test.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/auth/auth_state.dart';
import 'package:tale_ai_frontend/home/home_page.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

import '../test_apps/golden_test_app.dart';

void main() {
  testAdaptiveWidgets('Home page', (tester, windowConfig) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isLoggedInProvider.overrideWithValue(true),
        ],
        child: AdaptiveWrapper(
          windowConfig: windowConfig,
          tester: tester,
          child: const GoldenTestApp(
            themeMode: ThemeMode.dark,
            child: NavScaffold(
              selectedIndex: 0,
              child: HomePage(),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<HomePage>(windowConfig);
  });
}
