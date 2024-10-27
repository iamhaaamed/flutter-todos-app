import 'package:flutter_todos_app/common/constants/api_constants.dart';
import 'package:flutter_todos_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_todos_app/features/auth/data/repositories/shared_preferences_repository_impl.dart';
import 'package:flutter_todos_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_todos_app/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:flutter_todos_app/common/services/dio_client.dart';
import 'package:flutter_todos_app/features/todo/presentation/cubit/todo_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  await _initLocalStorage();
  _initNetwork();
  _initAuthFeature();
  _initTodoFeature();
}

// Local Storage Initialization
Future<void> _initLocalStorage() async {
  final preferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => preferences);
  getIt.registerLazySingleton<SharedPreferencesRepositoryImpl>(
    () => SharedPreferencesRepositoryImpl(getIt()),
  );
}

// Network Initialization
void _initNetwork() {
  final dioClient = DioClient(baseUrl: ApiConstants.currentBaseUrl);
  getIt.registerLazySingleton(() => dioClient);
  getIt.registerLazySingleton(() => dioClient.dio);
}

// Auth Feature Initialization
void _initAuthFeature() {
  getIt.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(getIt()),
  );
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));
}

// Todo Feature Initialization
void _initTodoFeature() {
  getIt.registerLazySingleton<TodoRepositoryImpl>(
    () => TodoRepositoryImpl(getIt()),
  );
  getIt.registerFactory<TodosCubit>(() => TodosCubit(getIt()));
}
