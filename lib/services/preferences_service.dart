import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<void> saveLastInputAmount(double amount) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setDouble('lastInputAmount', amount);
  }

  Future<double?> getLastInputAmount() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getDouble('lastInputAmount');
  }
}
