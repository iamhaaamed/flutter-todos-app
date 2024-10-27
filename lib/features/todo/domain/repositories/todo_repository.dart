import 'package:flutter_todos_app/features/todo/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<Map<String, dynamic>> getTodos();
  Future<Todo> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
  Future<void> toggleIsChecked({
    required String id,
    required bool isChecked,
  });
}
