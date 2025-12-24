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

String _searchQuery = '';

class _HomePageState extends State<HomePage> {
  Color lockColor = Colors.grey;
  int _currentTab = 0; // Changes when clicked
  final ScrollController _scrollController = ScrollController();
  final _authService = LocalAuthService();

  Future<void> _handleLock() async {
    final authenticated = await _authService.authenticateWithBiometrics();
    try {
      if (authenticated && mounted) {
        context.go('/private_notes_list');
        print('success');
      }
    } catch (e) {
      print('fail');
    }
  }

  @override
  void initState() {
    // TODO: fetch notes
    //fetchNotes();
    super.initState();
  }

  void _onSelectedTab(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  // Future fetchNotes() async {
  //   final box = Hive.box<hive.Note>('notes');
  //   try {
  //     final hiveNotes = box.values.toList();
  //     final domainNotes = hiveNotes.map((hiveNote) {
  //       return domain.Note(
  //         key: hiveNote.key,
  //         title: hiveNote.title,
  //         content: hiveNote.content,
  //         isPinned: hiveNote.isPinned,
  //       );
  //     }).toList();
  //     return domainNotes;
  //   } catch (e) {
  //     print('Error fetching notes: $e');
  //     return [];
  //   }
  // }
  //
  // List<domain.Note> filteredNotes(required String query) {
  //   final box = Hive.box<hive.Note>('notes');
  //   final hiveNotes = box.values.toList();
  //   if (hiveNotes.isEmpty){
  //     return [];
  //   }else{
  //
  //   }
  // }

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                //alignment: Alignment.centerLeft,
                children: [
                  Text(
                    'Your Notes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: SizedBox(
                      height: 35,
                      child: TextField(
                        onChanged: (value) {
                          // solution : just wrap the query to setstate since we want it to change
                          setState(() {
                            _searchQuery = value.trim().toLowerCase();
                          });
                          //_searchQuery = value.trim().toLowerCase();
                        },
                        decoration: InputDecoration(
                          isDense: false,
                          hintText: 'Search',
                          focusColor: Colors.grey,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 15,
                            color: Colors.grey,
                          ),
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(30),
                          // ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF202020), width: 0),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF202020), width: 0),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                  ),
                ],
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

                  // this is the holder of the notes so call it or set it
                  var displayedNotes = _currentTab == 0
                      ? domainNotes.reversed.toList()
                      : domainNotes.reversed
                            .where((note) => note.isPinned)
                            .toList();

                  if (_searchQuery.isNotEmpty) {
                    final filteredNotes = _searchQuery
                        .split(' ')
                        .where((test) => test.isNotEmpty)
                        .toList();
                    displayedNotes = displayedNotes.where((note) {
                      final noteText = '${note.title} ${note.content}'
                          .toLowerCase();
                      return filteredNotes.every(
                        (term) => noteText.contains(term),
                      );
                    }).toList();
                  }

                  if (displayedNotes.isEmpty) {
                    return Center(
                      child: Text(
                        _searchQuery.isNotEmpty
                            ? "No matching notes."
                            : (_currentTab == 1
                                  ? "No pinned notes."
                                  : "You don't have any notes yet."),
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
                  TodosCard(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                  ),
                  const Spacer(),
                  Privatecard(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
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
