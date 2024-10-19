import 'package:flutter/material.dart';
import 'package:flutter_todos_app/common/styles/color_palettes.dart';
import 'package:flutter_todos_app/cubit/todo/todo_cubit.dart';
import 'package:flutter_todos_app/cubit/todo/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_app/models/todo.dart';
import 'package:flutter_todos_app/screens/todo_details_page.dart';

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
          if (state is TodosSuccess) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return ListTile(
                  title: Text(state.todos[index].title),
                  subtitle: Text(state.todos[index].description),
                  leading: Checkbox(
                    onChanged: (value) {
                      context.read<TodosCubit>().toggleTodo(
                            id: todo.id,
                            isChecked: !state.todos[index].isChecked,
                          );
                    },
                    value: state.todos[index].isChecked,
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
          } else if (state is TodoFailure) {
            return Text(
              state.error.toString(),
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

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  @override
  _AddTodoDialogState createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isChecked = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Todo'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            CheckboxListTile(
              title: const Text('Completed'),
              value: _isChecked,
              onChanged: (value) {
                setState(() {
                  _isChecked = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final todo = Todo(
                id: '0',
                title: _titleController.text,
                description: _descriptionController.text,
                isChecked: _isChecked,
              );
              context.read<TodosCubit>().addTodo(todo);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
