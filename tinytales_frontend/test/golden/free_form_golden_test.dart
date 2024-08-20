import 'package:adaptive_test/adaptive_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/auth/auth_state.dart';
import 'package:tale_ai_frontend/freeform/data/freeform_service.dart';
import 'package:tale_ai_frontend/freeform/freeform_page.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

import '../mock_services/mock_freeform_service.dart';
import '../test_apps/golden_test_app.dart';
import '../test_data/free_form_proposal_test_data.dart';

void main() {
  final freeformTextField = find.byType(ValidationTextField);

  testAdaptiveWidgets('Free form', (tester, windowConfig) async {
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
            child: FreeformPage(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(
      freeformTextField,
      'test description',
    );

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tester.expectGolden<FreeformPage>(
      windowConfig,
      suffix: 'step_1',
      waitForImages: false,
    );
  });

  testAdaptiveWidgets('Free form next step', (tester, windowConfig) async {
    final localizations = lookupAppLocalizations(const Locale('en'));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isLoggedInProvider.overrideWithValue(true),
          freeformServiceProvider.overrideWith(
            (ref) => MockFreeformService(
              proposals: [
                aFreeFormProposal(title: 'test title'),
                aFreeFormProposal(title: 'test title 2'),
                aFreeFormProposal(title: 'test title 3'),
              ],
            ),
          ),
        ],
        child: AdaptiveWrapper(
          windowConfig: windowConfig,
          tester: tester,
          child: const GoldenTestApp(
            themeMode: ThemeMode.dark,
            child: FreeformPage(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(
      freeformTextField,
      'test description',
    );

    await tester.pump(const Duration(seconds: 2));

    await tester.dragUntilVisible(
      find.text(localizations.storyCreatorActionNext),
      find.byType(FreeformPage),
      const Offset(0, -100),
    );

    await tester.tap(
      find.text(localizations.storyCreatorActionNext),
      warnIfMissed: false,
    );

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    await tester.expectGolden<FreeformPage>(
      windowConfig,
      suffix: 'step_2',
      waitForImages: false,
    );
  });
}
