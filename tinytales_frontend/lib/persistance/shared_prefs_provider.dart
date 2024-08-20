import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_prefs_provider.g.dart';

@riverpod
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError('Should be overridden at the start of the app.');
}
