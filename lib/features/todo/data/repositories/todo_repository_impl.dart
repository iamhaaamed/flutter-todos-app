import 'package:dio/dio.dart';
import 'package:flutter_todos_app/features/todo/domain/entities/todo.dart';
import 'package:flutter_todos_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:flutter_todos_app/common/constants/api_constants.dart';

class TodoRepositoryImpl extends TodoRepository {
  final Dio _dio;

  TodoRepositoryImpl(this._dio);

  @override
  Future<List<Todo>> getTodos() async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrlDebug}/todos');
      final List<dynamic> data = response.data;

      return data.map((json) => Todo.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load todos $e');
    }
  }

  @override
  Future<Todo> addTodo(Todo todo) async {
    try {
      final response = await _dio.post('${ApiConstants.baseUrlDebug}/todos',
          data: todo.toJson());
      final dynamic data = response.data;

      return Todo.fromJson(data);
    } catch (e) {
      throw Exception('Failed to add todo $e');
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    try {
      await _dio.put('${ApiConstants.baseUrlDebug}/todos/${todo.id}',
          data: todo.toJson());
    } catch (e) {
      throw Exception('Failed to update todo $e');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      await _dio.delete('${ApiConstants.baseUrlDebug}/todos/$id');
    } catch (e) {
      throw Exception('Failed to delete todo $e');
    }
  }

  @override
  Future<void> toggleIsChecked(
      {required String id, required bool isChecked}) async {
    try {
      await _dio.patch(
        '${ApiConstants.baseUrlDebug}/todos/$id',
        data: {
          "isChecked": isChecked,
        },
      );
    } on DioException catch (e) {
      throw Exception('Failed to toggle todo $e');
    }
  }
}
