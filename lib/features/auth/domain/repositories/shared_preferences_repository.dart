abstract class SharedPreferencesRepository {
  Future<void> setOnboardingViewed(bool viewed);
  Future<bool> isOnboardingViewed();
}
