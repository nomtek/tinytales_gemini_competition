// ignore_for_file: unused_element

import 'package:flutter/material.dart';

const appDimensions = AppDimensions._();

class AppDimensions {
  const AppDimensions._({
    this.circleBorderRadius = 12,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.pageHorizontalPadding = 24,
    this.pageVerticalPadding = 24,
  });

  /// standard border radius value for the app
  final double circleBorderRadius;

  /// standard border radius for the app
  final BorderRadius borderRadius;

  /// standard horizontal padding for the app
  final double pageHorizontalPadding;

  /// standard vertical padding for the app
  final double pageVerticalPadding;
}
