import 'package:bloc/bloc.dart';
import 'package:flutter_todos_app/common/model/delayed_result.dart';
import 'package:flutter_todos_app/todo/domain/model/todo.dart';
import 'package:flutter_todos_app/todo/data/service/todo_service.dart';
import 'package:flutter_todos_app/todo/presentation/cubit/todo_state.dart';

class TodosCubit extends Cubit<TodosState> {
  final TodoService service;

  TodosCubit(this.service) : super(const TodosState());

  Future<void> fetchTodos({String? term}) async {
    try {
      emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));
      List<Todo> todos = await service.getTodos();
      emit(state.copyWith(items: todos));
      emit(state.copyWith(loadingResult: const DelayedResult.idle()));
    } on Exception catch (ex) {
      emit(state.copyWith(loadingResult: DelayedResult.fromError(ex)));
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));

      // Manually assign the correct ID before adding the todo
      final newId =
          (state.items.isNotEmpty ? (int.parse(state.items.last.id) + 1) : 1)
              .toString();
      final todoWithId = todo.copyWith(id: newId);

      // Call the service to add the todo
      Todo addedTodo = await service.addTodo(todoWithId);

      // Emit the state with the new todo
      emit(state.copyWith(items: [...state.items, addedTodo]));
      emit(state.copyWith(loadingResult: const DelayedResult.idle()));
    } on Exception catch (ex) {
      emit(state.copyWith(loadingResult: DelayedResult.fromError(ex)));
    }
  }

  Future<void> deleteTodo({
    required String id,
  }) async {
    try {
      emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));

      await service.deleteTodo(id);
      state.items.removeWhere((item) => item.id == id);

      emit(state.copyWith(items: state.items));
      emit(state.copyWith(loadingResult: const DelayedResult.idle()));
    } on Exception catch (ex) {
      emit(state.copyWith(loadingResult: DelayedResult.fromError(ex)));
    }
  }

  Future<void> toggleTodo({
    required String id,
    required bool isChecked,
  }) async {
    try {
      emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));

      // Call the service to toggle the todo's isChecked status
      await service.toggleIsChecked(id: id, isChecked: isChecked);

      // Find the index of the todo in the items list
      final index = state.items.indexWhere((todo) => todo.id == id);

      if (index != -1) {
        // Use copyWith to create the updated todo and update the list
        final updatedItems = List<Todo>.from(state.items)
          ..[index] = state.items[index].copyWith(isChecked: isChecked);

        // Emit the new state with the updated items
        emit(state.copyWith(items: updatedItems));
      } else {
        // If the todo isn't found, emit an error
        emit(state.copyWith(
          loadingResult: DelayedResult.fromError(Exception('Todo not found')),
        ));
      }

      // Emit the idle state after successful toggle
      emit(state.copyWith(loadingResult: const DelayedResult.idle()));
    } on Exception catch (ex) {
      // Emit error state if something goes wrong
      emit(state.copyWith(loadingResult: DelayedResult.fromError(ex)));
    }
  }
}
