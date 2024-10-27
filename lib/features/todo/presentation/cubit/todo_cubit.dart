import 'package:bloc/bloc.dart';
import 'package:flutter_todos_app/common/constants/pagination_constants.dart';
import 'package:flutter_todos_app/common/model/delayed_result.dart';
import 'package:flutter_todos_app/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:flutter_todos_app/features/todo/domain/entities/todo.dart';
import 'package:flutter_todos_app/features/todo/presentation/cubit/todo_state.dart';

class TodosCubit extends Cubit<TodosState> {
  final TodoRepositoryImpl repository;
  int _currentPage = 1;
  final int _limit = PaginationConstants.itemsPerPage;
  bool _hasMore = true;

  TodosCubit(this.repository) : super(const TodosState());

  Future<void> fetchTodos({bool isNextPage = false}) async {
    if (state.loadingResult.isInProgress || (!_hasMore && isNextPage)) return;

    try {
      emit(state.copyWith(loadingResult: const DelayedResult.inProgress()));

      if (!isNextPage) {
        _currentPage = 1; // Reset page if not loading the next page
        _hasMore = true; // Reset _hasMore when starting a new fetch
      }

      final response =
          await repository.getTodos(page: _currentPage, limit: _limit);

      final todos = response['todos'] as List<Todo>;
      final pagination = response['pagination'] as Map<String, dynamic>;

      // Determine if more items are available
      _hasMore = pagination['next'] != null;
      if (_hasMore) {
        _currentPage++;
      }

      final newItems = isNextPage ? [...state.items, ...todos] : todos;
      emit(state.copyWith(
          items: newItems, loadingResult: const DelayedResult.idle()));
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

      // Call the repository to add the todo
      Todo addedTodo = await repository.addTodo(todoWithId);

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

      await repository.deleteTodo(id);
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

      // Call the repository to toggle the todo's isChecked status
      await repository.toggleIsChecked(id: id, isChecked: isChecked);

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
