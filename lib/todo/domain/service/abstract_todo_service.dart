import 'package:flutter_todos_app/todo/domain/model/todo.dart';

abstract class AbstractTodoService {
  Future<List<Todo>> getTodos();
  Future<Todo> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
  Future<void> toggleIsChecked({
    required String id,
    required bool isChecked,
  });
}
