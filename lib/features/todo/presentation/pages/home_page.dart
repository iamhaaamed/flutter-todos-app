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
  @override
  void initState() {
    super.initState();
    // Fetch todos when the page loads
    context.read<TodosCubit>().fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Example'),
      ),
      body: BlocBuilder<TodosCubit, TodosState>(
        builder: (context, state) {
          if (state.loadingResult.isIdle) {
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
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
                      // Dispatch event to remove todo from Cubit
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
          } else if (state.loadingResult.isError) {
            return Text(
              state.loadingResult.error.toString(),
              style: const TextStyle(color: ColorPalettes.red),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
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
}
