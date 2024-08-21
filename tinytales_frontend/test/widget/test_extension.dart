import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/story_creator/form/components.dart';

extension AiAutofillButtonX on AiAutofillButton {
  bool get enabled => onPressed != null;
}

extension DeviceSizeX on WidgetTester {
  // set the device size for the test
  Future<void> setDeviceSize(
    Size size, {
    double devicePixelRatio = 1,
  }) async {
    addTearDown(
      () {
        view.reset();
        binding.setSurfaceSize(null);
      },
    );

    view
      ..physicalSize = size
      ..devicePixelRatio = devicePixelRatio;
    await binding.setSurfaceSize(size);
  }
}
