import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/persistance/shared_prefs_provider.dart';

part 'theme_mode.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  static const _prefsKey = 'theme_mode';
  @override
  ThemeMode build() {
    final darkModePrefs =
        ref.read(sharedPreferencesProvider).getBool(_prefsKey);

    switch (darkModePrefs) {
      case null:
        return ThemeMode.system;
      case true:
        return ThemeMode.dark;
      case false:
        return ThemeMode.light;
    }
  }

  Future<void> setThemeMode(ThemeMode value) async {
    state = value;
    switch (value) {
      case ThemeMode.system:
        await ref.read(sharedPreferencesProvider).remove(_prefsKey);
      case ThemeMode.light:
        await ref.read(sharedPreferencesProvider).setBool(
              _prefsKey,
              false,
            );
      case ThemeMode.dark:
        await ref.read(sharedPreferencesProvider).setBool(
              _prefsKey,
              true,
            );
    }
  }
}
