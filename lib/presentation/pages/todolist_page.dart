import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../data/models/todolist.dart';

class TodolistPage extends StatefulWidget {
  final Todolist? todos;

  const TodolistPage({super.key, this.todos});

  @override
  State<StatefulWidget> createState() => _TodolistPageState();
}

class _TodolistPageState extends State<TodolistPage> {
  final _titleTodoController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.todos != null) {
      _titleTodoController.text = widget.todos!.todoList;
      _descriptionController.text = widget.todos!.description;
    }
  }

  @override
  void dispose() {
    _titleTodoController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }


  void saveTodo() {
    final titleTodo = _titleTodoController.text.trim();
    final description = _descriptionController.text;
    if (titleTodo.isEmpty) {
      if (description.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Title can't be empty",
              style: TextStyle(color: Color(0xFFF6D14C)),
            ),
            backgroundColor: const Color(0xFF242424),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      } else {
        Navigator.pop(context);
        return;
      }
    }
    final box = Hive.box<Todolist>('todos');
    //specific todos
    if (widget.todos != null) {
      widget.todos!.todoList = titleTodo;
      widget.todos!.description = description;
      widget.todos!.save();
    } else {
      final newTodo = Todolist(
        todoList: titleTodo,
        description: description,
        isDone: false,
      );

      // Add to the box
      box.add(newTodo);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181818),
        leading: IconButton(
          onPressed: saveTodo,
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Todo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // Title Input
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF242424),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: _titleTodoController,
                  autofocus: true,
                  maxLength: 50,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    counterStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Description Input (Optional)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF242424),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 5,
                  maxLength: 200,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    counterStyle: TextStyle(color: Colors.grey),
                    alignLabelWithHint: true,
                  ),
                ),
              ),

              const Spacer(),

              // Save Button at Bottom
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: saveTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF6D14C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Add Todo',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
