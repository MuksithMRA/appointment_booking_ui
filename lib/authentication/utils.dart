import '../main.dart';

class Utils {
  static bool isLoggedIn() {
    return prefs.containsKey("token");
  }
}
