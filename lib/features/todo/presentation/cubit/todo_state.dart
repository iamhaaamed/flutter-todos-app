import 'package:equatable/equatable.dart';
import 'package:flutter_todos_app/common/model/delayed_result.dart';
import 'package:flutter_todos_app/features/todo/domain/entities/todo.dart';

class TodosState extends Equatable {
  final List<Todo> items;
  final DelayedResult<void> loadingResult;

  const TodosState({
    this.loadingResult = const DelayedResult.idle(),
    this.items = const [],
  });

  @override
  List<Object?> get props => [items, loadingResult];

  TodosState copyWith({
    List<Todo>? items,
    DelayedResult<void>? loadingResult,
  }) {
    return TodosState(
      items: items ?? this.items,
      loadingResult: loadingResult ?? this.loadingResult,
    );
  }
}
