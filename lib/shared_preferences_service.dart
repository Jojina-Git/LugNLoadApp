import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String isLoggedInKey = 'isLoggedIn';
  static const String userTypeKey = 'userType'; 

  static Future<void> saveLoginState(bool isLoggedIn, String userType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoggedInKey, isLoggedIn);
    await prefs.setString(userTypeKey, userType);
  }

  static Future<bool> getLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedInKey) ?? false;
  }

  static Future<String?> getUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userTypeKey);
  }

  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(isLoggedInKey);
    await prefs.remove(userTypeKey);
  }
}