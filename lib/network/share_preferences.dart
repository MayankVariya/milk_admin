import 'package:shared_preferences/shared_preferences.dart';

// Save login credentials to shared preferences
Future<void> saveLoginCredentials(String id, String pass,bool isprofilecomplited) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('id', id);
  await prefs.setString('pass', pass);
  await prefs.setBool('isLoggedIn', true);
  await prefs.setBool('isprofilecomplited', false);
 
}


// Remove login credentials from shared preferences
Future<void> removeLoginCredentials() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('id');
  await prefs.remove('pass');
  await prefs.setBool('isLoggedIn', false);
}
