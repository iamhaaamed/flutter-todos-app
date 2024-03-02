import 'package:dio/dio.dart';
import 'package:flutter_todos_app/models/todo.dart';
import 'package:flutter_todos_app/network/api/api_constants.dart';

class TodoService {
  final Dio _dio;

  TodoService(this._dio);

  Future<List<Todo>> getTodos() async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrlDebug}/todos');
      final List<dynamic> data = response.data;

      return data.map((json) => Todo.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load todos $e');
    }
  }

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

  Future<void> updateTodo(Todo todo) async {
    try {
      await _dio.put('${ApiConstants.baseUrlDebug}/todos/${todo.id}',
          data: todo.toJson());
    } catch (e) {
      throw Exception('Failed to update todo $e');
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await _dio.delete('${ApiConstants.baseUrlDebug}/todos/$id');
    } catch (e) {
      throw Exception('Failed to delete todo $e');
    }
  }

  Future<void> toggleIsChecked(
      {required int id, required bool isChecked}) async {
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
