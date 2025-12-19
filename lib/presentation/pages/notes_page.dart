import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_it/data/mapper/note_mapper.dart';
import 'package:notes_it/data/models/note.dart' as hive;
import 'package:notes_it/domain/models/note.dart' as domain;

class NotesPage extends StatefulWidget {
  final domain.Note? note;

  const NotesPage({super.key, this.note});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final ScrollController _scrollController = ScrollController();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final titleText = _titleController.text;
    final contentText = _contentController.text;

    if (titleText.isEmpty && contentText.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final box = Hive.box<hive.Note>('notes');

    if (widget.note != null) {
      final updatedDomainNote = widget.note!.copyWith(
        title: titleText,
        content: contentText,
      );
      final hiveNote = updatedDomainNote.toEntity();
      box.put(widget.note!.key, hiveNote);
    } else {
      final newDomainNote = domain.Note(
        title: titleText.isNotEmpty ? titleText : "Untitled Note",
        content: contentText,
      );
      final hiveNote = newDomainNote.toEntity();
      box.add(hiveNote);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      appBar: AppBar(
        leading: IconButton(
          onPressed: _saveNote,
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.note != null ? "Edit your note" : "What's on your mind?",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
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
                    controller: _contentController,
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
        onPressed: _saveNote,
        child: const Icon(Icons.save_alt),
      ),
    );
  }
}
