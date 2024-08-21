import 'dart:async';

import 'package:adaptive_test/adaptive_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

final defaultDeviceConfigs = {
  desktop,
  pixel5,
  iPhone13,
  iPadPro,
  iPhone8,
};

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadFontsFromPackage(
    package: Package(
      name: 'tale_ai_frontend',
      relativePath: 'assets',
    ),
  );
  late final TargetPlatform testPlatform;
  if (const bool.fromEnvironment('CI')) {
    testPlatform = TargetPlatform.linux;
  } else {
    // macOS is the default due to all team members using macOS.
    testPlatform = TargetPlatform.macOS;
  }
  debugPrint('Running tests on $testPlatform');
  AdaptiveTestConfiguration.instance
    ..setDeviceVariants(defaultDeviceConfigs)
    ..setEnforcedTestPlatform(testPlatform);
  setupFileComparatorWithThreshold(0.0006);
  await testMain();
}
