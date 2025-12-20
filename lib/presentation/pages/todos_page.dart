import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_it/data/mapper/todolist_mapper.dart';
import '../../data/models/todolist.dart' as hiveTodo;
import '../../domain/models/todolist.dart' as domainTodo;

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
            Navigator.pop(context);
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

                  final todos = domainTodos.where((todo) => !todo.isDone || todo.isDone).toList();

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
                      return _buildtoDoCard(todo);
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

  Widget _buildtoDoCard(domainTodo.Todolist todo) {
    return Card(
      color: const Color(0xFF202020),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
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
              icon: Icon(todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
                  //Icons.check_box_outline_blank, color: Colors.grey
              ),
              onPressed: () {
                if(todo.isDone == false){
                  final updatedTodo = todo.copyWith(isDone: true);
                  final hiveTodoItem = updatedTodo.toEntity();
                  Hive.box<hiveTodo.Todolist>('todos').put(todo.key, hiveTodoItem);
                }else{
                  final updatedTodo = todo.copyWith(isDone: false);
                  final hiveTodoItem = updatedTodo.toEntity();
                  Hive.box<hiveTodo.Todolist>('todos').put(todo.key, hiveTodoItem);
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
