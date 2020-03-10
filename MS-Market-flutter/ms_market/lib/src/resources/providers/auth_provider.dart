
import 'package:ms_market/src/models/authorization_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider {

  Future<void> persistToken(AuthorizationToken token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token.token);
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
  }

  Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    return  prefs.containsKey("token");
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return  prefs.get("token");
  }
}