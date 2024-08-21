import 'package:adaptive_test/adaptive_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tale_ai_frontend/settings/settings_page.dart';
import 'package:tale_ai_frontend/theme/theme_mode.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

import '../test_apps/golden_test_app.dart';

void main() {
  testAdaptiveWidgets('Settings page', (tester, windowConfig) async {
    PackageInfo.setMockInitialValues(
      appName: 'TinyTales AI',
      packageName: 'name',
      version: '1',
      buildNumber: '1',
      buildSignature: '1',
    );
    await tester.pumpSettingsPage(windowConfig: windowConfig);
    await tester.pumpAndSettle();

    await tester.expectGolden<SettingsPage>(
      windowConfig,
      waitForImages: false,
    );
  });

  testAdaptiveWidgets('Settings page version long',
      (tester, windowConfig) async {
    PackageInfo.setMockInitialValues(
      appName: 'TinyTales AI',
      packageName: 'test_package_name',
      version: '20.10.15',
      buildNumber: '2235',
      buildSignature: '23546246',
    );

    await tester.pumpSettingsPage(windowConfig: windowConfig);
    await tester.pumpAndSettle();

    await tester.expectGolden<SettingsPage>(
      windowConfig,
      suffix: 'long-version',
      waitForImages: false,
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSettingsPage({
    required WindowConfigData windowConfig,
  }) async {
    await pumpWidget(
      AdaptiveWrapper(
        windowConfig: windowConfig,
        tester: this,
        child: GoldenTestApp(
          overrides: [
            themeModeNotifierProvider.overrideWith(MockThemeModeNotifier.new),
          ],
          child: const NavScaffold(
            selectedIndex: 3,
            child: SettingsPage(),
          ),
        ),
      ),
    );
  }
}

class MockThemeModeNotifier extends ThemeModeNotifier {
  MockThemeModeNotifier([ThemeMode mode = ThemeMode.system]) : _mode = mode;

  final ThemeMode _mode;

  @override
  ThemeMode build() => _mode;
}
