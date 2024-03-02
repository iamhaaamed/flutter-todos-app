import 'package:flutter_todos_app/models/todo.dart';

sealed class TodosState {}

final class TodosInitial extends TodosState {}

final class TodosLoading extends TodosState {}

final class TodosSuccess extends TodosState {
  final List<Todo> todos;

  TodosSuccess({required this.todos});
}

final class TodoFailure extends TodosState {
  final Object error;
  TodoFailure({required this.error});
}

final class AddTodoInitial extends TodosState {}

final class AddTodoLoading extends TodosState {}

final class AddTodoSuccess extends TodosState {}

final class AddTodoFailure extends TodosState {
  final Object error;
  AddTodoFailure({required this.error});
}

final class DeleteTodoInitial extends TodosState {}

final class DeleteTodoLoading extends TodosState {}

final class DeleteTodoSuccess extends TodosState {}

final class DeleteTodoFailure extends TodosState {
  final Object error;
  DeleteTodoFailure({required this.error});
}

final class ToggleTodoInitial extends TodosState {}

final class ToggleTodoLoading extends TodosState {}

final class ToggleTodoSuccess extends TodosState {}

final class ToggleTodoFailure extends TodosState {
  final Object error;
  ToggleTodoFailure({required this.error});
}
