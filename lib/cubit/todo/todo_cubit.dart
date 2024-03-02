import 'package:bloc/bloc.dart';
import 'package:flutter_todos_app/cubit/todo/todo_state.dart';
import 'package:flutter_todos_app/models/todo.dart';
import 'package:flutter_todos_app/services/todo_service.dart';

class TodosCubit extends Cubit<TodosState> {
  final TodoService service;
  List<Todo> todos = [];

  TodosCubit(this.service) : super(TodosInitial());

  Future<void> fetchTodos({String? term}) async {
    try {
      emit(TodosLoading());

      List<Todo> fetchedTodos = await service.getTodos();
      todos = fetchedTodos;
      emit(TodosSuccess(todos: todos));
    } catch (e) {
      emit(TodoFailure(error: e));
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      emit(AddTodoLoading());
      Todo newTodo = await service.addTodo(todo);
      todos.add(newTodo);

      emit(TodosSuccess(todos: todos));
    } catch (e) {
      emit(AddTodoFailure(error: e));
    }
  }

  Future<void> deleteTodo({
    required int id,
  }) async {
    try {
      emit(DeleteTodoLoading());

      await service.deleteTodo(id);
      todos.removeWhere((item) => item.id == id);

      emit(TodosSuccess(todos: todos));
    } catch (e) {
      emit(DeleteTodoFailure(error: e));
    }
  }

  Future<void> toggleTodo({
    required int id,
    required bool isChecked,
  }) async {
    try {
      emit(ToggleTodoLoading());

      await service.toggleIsChecked(id: id, isChecked: isChecked);
      final index = todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        todos[index] = todos[index].copyWith(isChecked: isChecked);
        emit(TodosSuccess(todos: todos));
      } else {
        emit(ToggleTodoFailure(error: 'Todo not found'));
      }
    } catch (e) {
      emit(ToggleTodoFailure(error: e));
    }
  }
}
