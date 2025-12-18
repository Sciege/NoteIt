import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_it/models/note.dart';

class NotesPage extends StatefulWidget {
  final Note? note;

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
      // Set initial values for editing
      _contentController.text = widget.note!.content;
      _titleController.text = widget.note!.title;
    }
    _contentController.addListener(_updateWordCount);
  }

  @override
  void dispose() {
    _contentController.removeListener(_updateWordCount);
    _titleController.dispose();
    _contentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateWordCount() {
    setState(() {
      _wordCount = _contentController.text.trim().isEmpty
          ? 0
          : _contentController.text.trim().split(RegExp(r'\s+')).length;
    });
  }

  void _saveNote() {
    final titleText = _titleController.text;
    final contentText = _contentController.text;
    if (contentText.isNotEmpty) {
      final box = Hive.box<Note>('notes');

      if (widget.note != null) {
        // Update existing note
        widget.note!.title = titleText;
        widget.note!.content = contentText;
        widget.note!.save();
      } else {
        // Create new note
        final newNote = Note(title: titleText, content: contentText);
        box.add(newNote);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
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
        hoverColor: const Color(0xFFFFBD00),
        onPressed: _saveNote,
        child: const Icon(Icons.save_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
