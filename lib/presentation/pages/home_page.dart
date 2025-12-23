import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_it/presentation/widgets/home_page_widgets/NoteCard.dart';
import 'package:notes_it/presentation/widgets/home_page_widgets/PrivateCard.dart';
import 'package:notes_it/presentation/widgets/home_page_widgets/Tabs.dart';
import 'package:notes_it/presentation/widgets/home_page_widgets/TodosCard.dart';

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
import 'package:go_router/go_router.dart';

// widgets
import '../widgets/home_page_widgets/FloatingActionBottomBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color lockColor = Colors.grey;
  int _currentTab = 0; // Changes when clicked
  final ScrollController _scrollController = ScrollController();
  final _authService = LocalAuthService();

  Future<void> _handleLock() async {
    final authenticated = await _authService.authenticateWithBiometrics();
    if (authenticated && mounted) {
      context.go('/private_notes_list');
    }
  }

  void _onSelectedTab(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    late double screenHeight = MediaQuery.of(context).size.height;
    late double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      appBar: AppBar(),
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
                children: [
                  Tabs(
                    head: 'All',
                    ind: 0,
                    selectedTab: _onSelectedTab,
                    currentTab: _currentTab,
                  ),
                  Tabs(
                    head: 'Pinned',
                    ind: 1,
                    selectedTab: _onSelectedTab,
                    currentTab: _currentTab,
                  ),
                ],
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

                  final displayedNotes = _currentTab == 0
                      ? domainNotes.reversed.toList()
                      : domainNotes.reversed
                            .where((note) => note.isPinned)
                            .toList();

                  if (displayedNotes.isEmpty) {
                    return Center(
                      child: Text(
                        _currentTab == 1
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
                  TodosCard(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                  ),
                  const Spacer(),
                  Privatecard(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    //  lockColor: lockColor,
                    onUnlock: _handleLock,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionBottomBar(handleLock: _handleLock),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildNotesList(List<domain.Note> displayedNotes) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: displayedNotes.length,
      itemBuilder: (context, index) {
        final note = displayedNotes[index];
        return Notecard(note: note);
      },
    );
  }
}
