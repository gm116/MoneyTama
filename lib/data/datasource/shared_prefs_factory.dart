import 'package:shared_preferences/shared_preferences.dart';
import 'shared_prefs_datasource.dart';

class SharedPrefsFactory {
  static Future<SharedPrefsDataSource> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefsDataSource(prefs);
  }
}