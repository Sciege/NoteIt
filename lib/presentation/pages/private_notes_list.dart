import 'package:flutter/material.dart';

//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_it/presentation/pages/private_notes.dart';
import 'package:notes_it/presentation/pages/todolist_page.dart';
import 'package:notes_it/presentation/widgets/private_notes_list_widgets/NoteCard.dart';

import '../../data/models/priv_notes.dart' as hive;

import '../../domain/models/priv_notes.dart' as domain;
import 'package:go_router/go_router.dart';

import '../widgets/private_notes_list_widgets/NotesList.dart';

class PrivateNotesList extends StatefulWidget {
  const PrivateNotesList({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PrivateNotesListState();
  }
}

class _PrivateNotesListState extends State<PrivateNotesList> {
  ScrollController _scrollController = ScrollController();

  // int _selectedTab = 0; // Changes when clicked
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
        child: SafeArea(
          child: Column(
            children: [
              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your Private Notes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 20),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   child: Row(
              //     children: [_buildTab('All', 0), _buildTab('Pinned', 1)],
              //   ),
              // ),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ValueListenableBuilder<Box<hive.PrivNotes>>(
                  valueListenable: Hive.box<hive.PrivNotes>(
                    'priv_notes',
                  ).listenable(),
                  builder: (context, box, _) {
                    if (box.isEmpty) {
                      return const Center(
                        child: Text(
                          "You don't have any notes yet.",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    // CORRECT MAPPING: Iterate over keys to build domain models
                    final domainNotes = box.keys.map((key) {
                      final hiveNote = box.get(key)!;
                      return domain.PrivNotes(
                        key: key,
                        title: hiveNote.title,
                        content: hiveNote.content,
                      );
                    }).toList();

                    final displayedNotes = domainNotes.toList();

                    if (displayedNotes.isEmpty) {
                      return Center(
                        child: Text(
                          "You don't have any private notes yet.",
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return Noteslist(displayedNotes: displayedNotes);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit_outlined),
        onPressed: () {
          //PrivNotes
          context.go('/private_notes');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
