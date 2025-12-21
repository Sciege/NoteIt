import 'package:flutter/material.dart';

//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_it/presentation/pages/private_notes.dart';
import 'package:notes_it/presentation/pages/todolist_page.dart';

import '../../data/models/priv_notes.dart' as hive;

import '../../domain/models/priv_notes.dart' as domain;
//import 'notes_page.dart';

//import '../../data/models/note.dart' as hive;

class PrivateNotesList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PrivateNotesListState();
  }
}

class _PrivateNotesListState extends State<PrivateNotesList> {
  ScrollController _scrollController = ScrollController();
  int _selectedTab = 0; // Changes when clicked
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
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
                    return _buildNotesList(displayedNotes);
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PrivNotes()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildNotesList(List<domain.PrivNotes> displayedNotes) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: displayedNotes.length,
      itemBuilder: (context, index) {
        final note = displayedNotes[index];
        return _buildNoteCard(note);
      },
    );
  }

  Widget _buildNoteCard(domain.PrivNotes note) {
    return Card(
      color: const Color(0xFF202020),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PrivNotes()),
          );
        },
        title: Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          // Have max characters trailing
          note.content.length >= 15
              ? note.content.substring(0, 15) + '...'
              : note.content,
          //note.content,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // IconButton(
            //   icon: Icon(
            //     note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            //     color: note.isPinned ? const Color(0xFFF6D14C) : Colors.grey,
            //   ),
            //   onPressed: () {
            //     final updatedDomainNote = note.copyWith(
            //       isPinned: !note.isPinned,
            //     );
            //     final hiveNote = updatedDomainNote.toEntity();
            //     Hive.box<hive.PrivNotes>('notes').put(note.key, hiveNote);
            //   },
            // ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: () {
                Hive.box<hive.PrivNotes>('priv_notes').delete(note.key);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionBottomBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 150),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF202020),
        borderRadius: BorderRadius.circular(30),
      ),
      child: SizedBox(
        width: double.infinity,
        child:
            // IconButton(
            //   icon: const Icon(Icons.check_box_outlined, color: Colors.white),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => TodolistPage()),
            //     );
            //   },
            // ),
            //
            // const Spacer(),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color(0xFFF6D14C),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.black,
                  size: 25,
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PrivNotes()),
                  );
                },
              ),
            ),

        //
        // const Spacer(),
        // IconButton(
        //   icon: const Icon(Icons.lock_outline, color: Colors.white),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       //todo set up
        //       MaterialPageRoute(builder: (context) => TodolistPage()),
        //     );
        //   },
        // ),
      ),
    );
  }
}
