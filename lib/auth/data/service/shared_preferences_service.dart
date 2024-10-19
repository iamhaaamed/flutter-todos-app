import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  Future<void> setOnboardingViewed(bool viewed) async {
    await _prefs.setBool('onboarding_viewed', viewed);
  }

  Future<bool> isOnboardingViewed() async {
    return _prefs.getBool('onboarding_viewed') ?? false;
  }
}
