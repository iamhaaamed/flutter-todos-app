import 'package:flutter/material.dart';
import 'package:flutter_todos_app/constants/app_sizes.dart';
import 'package:flutter_todos_app/models/todo.dart';

class TodoDetailsPage extends StatelessWidget {
  static const routeName = '/todoDetails';
  const TodoDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the todo object passed as arguments during navigation
    final Todo todo = ModalRoute.of(context)!.settings.arguments as Todo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${todo.title}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: ${todo.description}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Completed: ${todo.isChecked ? "Yes" : "No"}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
