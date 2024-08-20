import 'package:flutter/foundation.dart';

extension StringExtensions on String? {
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;
  bool get isNotNullOrBlank => !isNullOrBlank;
}

extension StringExtension on String {
  bool get isBlank => trim().isEmpty;
}

final isMobilePlatform = defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

final isMobileWeb = kIsWeb && isMobilePlatform;
