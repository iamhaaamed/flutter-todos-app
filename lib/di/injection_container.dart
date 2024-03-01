import 'package:flutter_todos_app/services/shared_preferences_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Local
  final preferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => preferences);
  getIt.registerLazySingleton(
      () => SharedPreferencesService(getIt<SharedPreferences>()));
}
