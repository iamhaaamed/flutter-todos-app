import 'package:flutter_todos_app/auth/data/service/auth_service.dart';
import 'package:flutter_todos_app/auth/data/service/shared_preferences_service.dart';
import 'package:flutter_todos_app/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_todos_app/network/api/dio_client.dart';
import 'package:flutter_todos_app/todo/data/service/todo_service.dart';
import 'package:flutter_todos_app/todo/presentation/cubit/todo_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init(String baseUrl) async {
  // Cubit
  getIt.registerFactory(() => AuthCubit(getIt()));
  getIt.registerFactory(() => TodosCubit(getIt()));

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
  getIt.registerLazySingleton(() => TodoService(getIt()));
}
