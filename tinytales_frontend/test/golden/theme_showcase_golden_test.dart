import 'package:adaptive_test/adaptive_test.dart';
import 'package:tale_ai_frontend/debug/theme.dart';

import '../test_apps/golden_test_app.dart';

void main() {
  // test only for debugging fonts
  testAdaptiveWidgets(
    'Story creator first page',
    skip: true,
    (tester, windowConfig) async {
      await tester.pumpWidget(
        AdaptiveWrapper(
          windowConfig: windowConfig,
          tester: tester,
          child: const GoldenTestApp(
            child: ThemeShowcase(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.expectGolden<ThemeShowcase>(
        windowConfig,
        waitForImages: false,
      );
    },
  );
}
