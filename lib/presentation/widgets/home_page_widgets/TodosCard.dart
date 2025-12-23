import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../data/models/todolist.dart' as hiveTodo;
import '../../../domain/models/todolist.dart' as domainTodo;
import 'ToDoCard.dart';

class TodosCard extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  TodosCard({super.key, required this.screenHeight, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: screenHeight * 0.3,
      width: screenWidth * 0.41,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ValueListenableBuilder<Box<hiveTodo.Todolist>>(
        valueListenable: Hive.box<hiveTodo.Todolist>('todos').listenable(),
        builder: (context, box, _) {
          // Filter not done
          //TODO
          final domainTodos = box.keys.map((key) {
            final hiveTodo_ = box.get(key)!;
            return domainTodo.Todolist(
              key: key,
              todolist: hiveTodo_.todoList,
              description: hiveTodo_.description,
              isDone: hiveTodo_.isDone,
            );
          }).toList();

          final activeTodos = domainTodos
              .where((todo) => !todo.isDone)
              .toList();

          Widget contentWidget;
          if (activeTodos.isEmpty) {
            contentWidget = const Center(
              child: Text(
                'No active todos',
                style: TextStyle(color: Color(0xFFF6D14C), fontSize: 12),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            contentWidget = ListView.builder(
              itemCount: activeTodos.length,
              itemBuilder: (context, index) {
                final todo = activeTodos[index];
                return Todocard(todo: todo);
              },
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // THE PERMANENT TITLE
              TextButton(
                onPressed: () {
                  //TodosPage
                  context.go('/todos_page');
                },
                child: Text(
                  'Todos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(child: contentWidget),
            ],
          );
        },
      ),
    );
  }
}
