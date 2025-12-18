import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_it/presentation/pages/notes_page.dart';

import '../../data/models/note.dart';
import '../../data/models/todolist.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTab = 0; // Changes when clicked
  final ScrollController _scrollController = ScrollController();
  late double screenHeight = MediaQuery.of(
    context,
  ).size.height; // For responsive height
  late double screenWidth = MediaQuery.of(
    context,
  ).size.width; // For responsive width

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: CircleAvatar(radius: 20),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your Notes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [_buildTab('All', 0), _buildTab('Pinned', 1)],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              // consume only portion of the screen
              height: MediaQuery.of(context).size.height * 0.3,
              child: Scrollbar(
                controller: _scrollController,
                child: ValueListenableBuilder<Box<Note>>(
                  valueListenable: Hive.box<Note>('notes').listenable(),
                  builder: (context, box, _) {
                    if (box.values.isEmpty) {
                      return const Center(
                        child: Text(
                          "You don't have any notes yet.",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    // Filter based on selected tab
                    final notes = box.values.toList();
                    final displayedNotes = _selectedTab == 0
                        ? notes
                        : notes.where((note) => note.isPinned).toList();

                    if (displayedNotes.isEmpty) {
                      return const Center(
                        child: Text(
                          "No pinned notes yet.",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return _buildNotesList(displayedNotes);
                  },
                ),
              ),
            ),
            Divider(height: screenHeight * 0.03, color: Color(0xFF181818)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  _buildTodoList(),
                  Spacer(),
                  _buildPrivate(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionBottomBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTodoList() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 0),
          // todolist
          child: Container(
            height: screenHeight * 0.3,
            width: screenWidth * 0.41,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF242424),
              borderRadius: BorderRadius.circular(10),
            ),
            // todolist viewbuilder
          ),
        ),
      ],
    );
  }

  Widget _buildPrivate() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 0),
          // todolist
          child: Container(
            height: screenHeight * 0.3,
            width: screenWidth * 0.41,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF242424),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildNotesList(List<Note> displayedNotes) {
    return ListView.builder(
      itemCount: displayedNotes.length,
      itemBuilder: (context, index) {
        final note = displayedNotes[index];
        return _buildNoteCard(note);
      },
    );
  }

  Widget _buildNoteCard(Note note) {
    return Card(
      color: const Color(0xFF202020),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotesPage(note: note)),
          );
        },
        title: Text(
          note.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: note.isPinned ? const Color(0xFFF6D14C) : Colors.grey,
              ),
              onPressed: () {
                note.isPinned = !note.isPinned;
                note.save();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: () => note.delete(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF6D14C) : const Color(0xFF202020),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionBottomBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 60),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF202020),
        borderRadius: BorderRadius.circular(30),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.check_box_outlined, color: Colors.white),
              onPressed: () {},
            ),

            const Spacer(),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFF6D14C),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.black, size: 28),
            ),

            const Spacer(),

            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotesPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
