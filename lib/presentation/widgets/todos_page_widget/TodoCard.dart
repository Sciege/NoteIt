import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../../data/mapper/todolist_mapper.dart';
import '../../../domain/models/todolist.dart' as domainTodo;
import '../../../data/models/todolist.dart' as hiveTodo;

class Todocard extends StatelessWidget {
  Todocard({super.key, required this.todo});

  final domainTodo.Todolist todo;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      color: const Color(0xFF202020),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        onTap: () {
          //NotesPage
          context.go('/todolist_page', extra: todo);
        },
        title: Text(
          todo.todolist,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          todo.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
                //Icons.check_box_outline_blank, color: Colors.grey
              ),
              onPressed: () {
                if (todo.isDone == false) {
                  final updatedTodo = todo.copyWith(isDone: true);
                  final hiveTodoItem = updatedTodo.toEntity();
                  Hive.box<hiveTodo.Todolist>(
                    'todos',
                  ).put(todo.key, hiveTodoItem);
                } else {
                  final updatedTodo = todo.copyWith(isDone: false);
                  final hiveTodoItem = updatedTodo.toEntity();
                  Hive.box<hiveTodo.Todolist>(
                    'todos',
                  ).put(todo.key, hiveTodoItem);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: () {
                Hive.box<hiveTodo.Todolist>('todos').delete(todo.key);
              },
            ),
          ],
        ),
      ),
    );
  }
}
