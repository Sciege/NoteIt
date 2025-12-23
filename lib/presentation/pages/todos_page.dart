import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_it/data/mapper/todolist_mapper.dart';
import 'package:notes_it/presentation/widgets/todos_page_widget/TodoCard.dart';
import '../../data/models/todolist.dart' as hiveTodo;
import '../../domain/models/todolist.dart' as domainTodo;
import 'package:go_router/go_router.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<StatefulWidget> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go('/');
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Your Todos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder<Box<hiveTodo.Todolist>>(
                valueListenable: Hive.box<hiveTodo.Todolist>(
                  'todos',
                ).listenable(),
                builder: (context, box, _) {
                  final domainTodos = box.keys.map((key) {
                    final hiveTodo_ = box.get(key)!;
                    return domainTodo.Todolist(
                      key: key,
                      todolist: hiveTodo_.todoList,
                      description: hiveTodo_.description,
                      isDone: hiveTodo_.isDone,
                    );
                  }).toList();

                  final todos = domainTodos
                      .where((todo) => !todo.isDone || todo.isDone)
                      .toList();

                  if (todos.isEmpty) {
                    return const Center(
                      child: Text(
                        'No active todos',
                        style: TextStyle(
                          color: Color(0xFFF6D14C),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return Todocard(todo: todo);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
