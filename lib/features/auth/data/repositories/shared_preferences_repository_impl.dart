import 'package:flutter_todos_app/features/auth/domain/repositories/shared_preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepositoryImpl extends SharedPreferencesRepository {
  final SharedPreferences _prefs;

  SharedPreferencesRepositoryImpl(this._prefs);

  @override
  Future<void> setOnboardingViewed(bool viewed) async {
    await _prefs.setBool('onboarding_viewed', viewed);
  }

  @override
  Future<bool> isOnboardingViewed() async {
    return _prefs.getBool('onboarding_viewed') ?? false;
  }
}
