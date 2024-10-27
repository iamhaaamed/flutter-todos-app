import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_todos_app/common/styles/color_palettes.dart';
import 'package:flutter_todos_app/features/todo/presentation/cubit/todo_cubit.dart';
import 'package:flutter_todos_app/features/todo/presentation/cubit/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_app/features/todo/presentation/pages/todo_details_page.dart';
import 'package:flutter_todos_app/features/todo/presentation/widgets/add_todo_dialog.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<TodosCubit>().fetchTodos();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      context.read<TodosCubit>().fetchTodos(isNextPage: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Example'),
      ),
      body: BlocBuilder<TodosCubit, TodosState>(
        builder: (context, state) {
          if (state.loadingResult.isIdle && state.items.isEmpty) {
            return const Center(child: Text('No todos available.'));
          } else if (state.loadingResult.isError) {
            return Center(
              child: Text(
                state.loadingResult.error.toString(),
                style: const TextStyle(color: ColorPalettes.red),
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount:
                state.items.length + (state.loadingResult.isInProgress ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.items.length) {
                return const Center(child: CircularProgressIndicator());
              }

              final todo = state.items[index];
              return ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.description),
                leading: Checkbox(
                  onChanged: (value) {
                    context.read<TodosCubit>().toggleTodo(
                          id: todo.id,
                          isChecked: !todo.isChecked,
                        );
                  },
                  value: todo.isChecked,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  color: ColorPalettes.red,
                  onPressed: () {
                    context.read<TodosCubit>().deleteTodo(id: todo.id);
                  },
                ),
                onTap: () => Navigator.pushNamed(
                  context,
                  TodoDetailsPage.routeName,
                  arguments: todo,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return const AddTodoDialog();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
