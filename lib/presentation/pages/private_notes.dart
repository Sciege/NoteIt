import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../data/mapper/priv_notes.dart';
import '../../data/models/priv_notes.dart' as hive;
import '../../domain/models/priv_notes.dart' as domain;

class PrivNotes extends StatefulWidget {
  final domain.PrivNotes? privNotes;

  const PrivNotes({super.key, this.privNotes});

  @override
  State<StatefulWidget> createState() {
    return _PrivNotesState();
  }
}

class _PrivNotesState extends State<PrivNotes> {
  final ScrollController _scrollController = ScrollController();
  final _titleNotesController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _wordCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.privNotes != null) {
      _titleNotesController.text = widget.privNotes!.title;
      _descriptionController.text = widget.privNotes!.content;
    }
  }

  @override
  void dispose() {
    _titleNotesController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void savePrivNotes() {
    final privTitleText = _titleNotesController.text.trim();
    final privContentText = _descriptionController.text;
    if (privTitleText.isEmpty) {
      if (privContentText.isNotEmpty) {
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
    final box = Hive.box<hive.PrivNotes>('priv_notes');
    //specific todos
    if (widget.privNotes != null) {
      // widget.todos!.todoList = privTitleText;
      // widget.todos!.privContentText = privContentText;
      // widget.todos!.save();
      final updatedDomainPrivNotes = widget.privNotes!.copyWith(
        title: privTitleText,
        content: privContentText,
      );

      final hiveTodo = updatedDomainPrivNotes.toEntity();
      box.put(widget.privNotes!.key, hiveTodo);
    } else {
      final newDomainTodolist = domain.PrivNotes(
        title: privTitleText,
        content: privContentText,
      );

      final newTodo = newDomainTodolist.toEntity();

      // Add to the box
      box.add(newTodo);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF181818),
        leading: IconButton(
          onPressed: savePrivNotes,
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Text('Word count: $_wordCount'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.privNotes != null
                    ? "Edit your Private Note"
                    : "What's your secret in mind?",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _titleNotesController,
                autofocus: false,
                keyboardType: TextInputType.multiline,
                maxLength: 30,
                style: TextStyle(color: Colors.white, fontSize: 22),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 22,
                  ),
                ),
              ),
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  child: TextField(
                    controller: _descriptionController,
                    autofocus: false,
                    // keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Start writing here...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: savePrivNotes,
        child: const Icon(Icons.save_alt),
      ),
    );
  }
}
