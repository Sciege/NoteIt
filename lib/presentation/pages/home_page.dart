import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_it/presentation/pages/notes_page.dart';
import 'package:notes_it/presentation/pages/private_notes.dart';
import 'package:notes_it/presentation/pages/todolist_page.dart';
import 'package:notes_it/presentation/pages/todos_page.dart';

//notes
import '../../data/mapper/note_mapper.dart';
import '../../data/models/note.dart' as hive;
import '../../domain/models/note.dart' as domain;

//todolist
import '../../data/mapper/todolist_mapper.dart';
import '../../data/models/todolist.dart' as hiveTodo;
import '../../domain/models/todolist.dart' as domainTodo;

// auth
import '../../core/services/local_auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color lockColor = Colors.grey;
  int _selectedTab = 0; // Changes when clicked
  final ScrollController _scrollController = ScrollController();

  final _authServices = LocalAuthService();

  Future _handleLock() async {
    bool authenticated = await _authServices.authenticateWithBiometrics();
    if (authenticated) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PrivateNotes()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    late double screenHeight = MediaQuery.of(context).size.height;
    late double screenWidth = MediaQuery.of(context).size.width;

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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: ValueListenableBuilder<Box<hive.Note>>(
                valueListenable: Hive.box<hive.Note>('notes').listenable(),
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
                    return domain.Note(
                      key: key,
                      title: hiveNote.title,
                      content: hiveNote.content,
                      isPinned: hiveNote.isPinned,
                    );
                  }).toList();

                  final displayedNotes = _selectedTab == 0
                      ? domainNotes.reversed.toList()
                      : domainNotes.reversed
                            .where((note) => note.isPinned)
                            .toList();

                  if (displayedNotes.isEmpty) {
                    return Center(
                      child: Text(
                        _selectedTab == 1
                            ? "No pinned notes."
                            : "You don't have any notes yet.",
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return _buildNotesList(displayedNotes);
                },
              ),
            ),
            const Divider(color: Color(0xFF181818)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  //_buildTodoList(screenHeight, screenWidth, hiveTodo),
                  _todosCard(screenHeight, screenWidth),
                  const Spacer(),
                  _buildPrivate(screenHeight, screenWidth),
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

  Widget _buildtoDoCard(domainTodo.Todolist todo) {
    return Card(
      color: const Color(0xFF202020),
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
      child: ListTile(
        horizontalTitleGap: 0,
        contentPadding: EdgeInsets.zero,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodolistPage(todos: todo)),
          );
        },
        leading: Checkbox(
          value: todo.isDone,
          activeColor: const Color(0xFFF6D14C),
          onChanged: (bool? value) {
            // Toggle completion
            // todo.isDone = value ?? false;
            // todo.save(); // Save to Hive
            final updatedTodo = todo.copyWith(isDone: value ?? false);

            // Convert to Hive entity
            final hiveTodo_ = updatedTodo.toEntity();

            // Save to Hive
            final box = Hive.box<hiveTodo.Todolist>('todos');
            box.put(todo.key, hiveTodo_);
          },
        ),
        title: Text(
          todo.todolist.length >= 8
              ? todo.todolist.substring(0, 8) + '...'
              : todo.todolist,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }

  Widget _todosCard(screenHeight, screenWidth) {
    return Container(
      height: screenHeight * 0.3,
      width: screenWidth * 0.41,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ValueListenableBuilder<Box<hiveTodo.Todolist>>(
        valueListenable: Hive.box<hiveTodo.Todolist>('todos').listenable(),
        builder: (context, box, _) {
          // Filter not done
          //TODO
          final domainTodos = box.keys.map((key) {
            final hiveTodo_ = box.get(key)!;
            return domainTodo.Todolist(
              key: key,
              todolist: hiveTodo_.todoList,
              description: hiveTodo_.description,
              isDone: hiveTodo_.isDone,
            );
          }).toList();

          final activeTodos = domainTodos
              .where((todo) => !todo.isDone)
              .toList();

          Widget contentWidget;
          if (activeTodos.isEmpty) {
            contentWidget = const Center(
              child: Text(
                'No active todos',
                style: TextStyle(color: Color(0xFFF6D14C), fontSize: 12),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            contentWidget = ListView.builder(
              itemCount: activeTodos.length,
              itemBuilder: (context, index) {
                final todo = activeTodos[index];
                return _buildtoDoCard(todo);
              },
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // THE PERMANENT TITLE
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TodosPage()),
                  );
                },
                child: Text(
                  'Todos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(child: contentWidget),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPrivate(double screenHeight, double screenWidth) {
    return Container(
      height: screenHeight * 0.3,
      width: screenWidth * 0.41,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: GestureDetector(
          onTapDown: (_) {
            setState(() {
              lockColor = const Color(0xFFF6D14C); // Yellow
            });
          },
          onTapCancel: () {
            setState(() {
              lockColor = Colors.grey;
            });
          },
          child: IconButton(
            color: lockColor,
            onPressed: _handleLock,
            iconSize: 30,
            icon: Icon(Icons.lock_outline),
          ),
        ),
      ),
    );
  }

  Widget _buildNotesList(List<domain.Note> displayedNotes) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: displayedNotes.length,
      itemBuilder: (context, index) {
        final note = displayedNotes[index];
        return _buildNoteCard(note);
      },
    );
  }

  Widget _buildNoteCard(domain.Note note) {
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
            IconButton(
              icon: Icon(
                note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: note.isPinned ? const Color(0xFFF6D14C) : Colors.grey,
              ),
              onPressed: () {
                final updatedDomainNote = note.copyWith(
                  isPinned: !note.isPinned,
                );
                final hiveNote = updatedDomainNote.toEntity();
                Hive.box<hive.Note>('notes').put(note.key, hiveNote);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: () {
                Hive.box<hive.Note>('notes').delete(note.key);
              },
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TodolistPage()),
                );
              },
            ),

            const Spacer(),
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
                    MaterialPageRoute(builder: (context) => const NotesPage()),
                  );
                },
              ),
            ),

            const Spacer(),
            IconButton(
              icon: const Icon(Icons.lock_outline, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  //todo set up
                  MaterialPageRoute(builder: (context) => TodolistPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
