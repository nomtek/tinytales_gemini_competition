import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeSharedPreferences extends Fake implements SharedPreferences {
  @override
  String? getString(String key) {
    return null;
  }
}
