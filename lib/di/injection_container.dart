import 'package:flutter_todos_app/cubit/auth/auth_cubit.dart';
import 'package:flutter_todos_app/cubit/todo/todo_cubit.dart';
import 'package:flutter_todos_app/network/api/dio_client.dart';
import 'package:flutter_todos_app/services/auth_service.dart';
import 'package:flutter_todos_app/services/shared_preferences_service.dart';
import 'package:flutter_todos_app/services/todo_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init(String baseUrl) async {
  // Cubit
  getIt.registerFactory(() => AuthCubit(getIt()));

  // Local
  final preferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => preferences);
  getIt.registerLazySingleton(
    () => SharedPreferencesService(
      getIt<SharedPreferences>(),
    ),
  );

  // Network
  final dioClient = DioClient(baseUrl: baseUrl);
  getIt.registerLazySingleton(() => dioClient);
  getIt.registerLazySingleton(() => dioClient.dio);
  getIt.registerLazySingleton(() => AuthService(getIt()));
}
