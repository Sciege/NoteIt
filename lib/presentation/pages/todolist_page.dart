import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_it/data/mapper/todolist_mapper.dart';

import '../../data/models/todolist.dart' as hive;
import '../../domain/models/todolist.dart' as domain;
import 'package:go_router/go_router.dart';

class TodolistPage extends StatefulWidget {
  final domain.Todolist? todos;

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
      _titleTodoController.text = widget.todos!.todolist;
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
        context.go('/');
        return;
      }
    }
    final box = Hive.box<hive.Todolist>('todos');
    //specific todos
    if (widget.todos != null) {
      // widget.todos!.todoList = titleTodo;
      // widget.todos!.description = description;
      // widget.todos!.save();
      final updatedDomainTodo = widget.todos!.copyWith(
        todolist: titleTodo,
        description: description,
      );

      final hiveTodo = updatedDomainTodo.toEntity();
      box.put(widget.todos!.key, hiveTodo);
    } else {
      final newDomainTodolist = domain.Todolist(
        todolist: titleTodo,
        description: description,
      );

      final newTodo = newDomainTodolist.toEntity();

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
                  autofocus: false,
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
                  child: Text(
                    // is there exisiting data? yes edit else add
                    widget.todos != null ? "Edit Todo" : "Add Todo",
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
