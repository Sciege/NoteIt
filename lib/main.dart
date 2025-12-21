import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_it/data/models/priv_notes.dart';
import 'package:notes_it/data/models/todolist.dart';
import 'package:notes_it/presentation/app_theme.dart';
import 'package:notes_it/presentation/pages/home_page.dart';
import 'package:notes_it/presentation/pages/notes_page.dart';
import 'package:notes_it/presentation/pages/private_notes.dart';
import 'package:notes_it/presentation/pages/private_notes_list.dart';
import 'package:notes_it/presentation/pages/todolist_page.dart';
import 'package:notes_it/presentation/pages/todos_page.dart';

import 'data/models/note.dart';

import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TodolistAdapter());
  Hive.registerAdapter(PrivNotesAdapter());
  //  await Hive.deleteBoxFromDisk('notes'); //to be deleted in prod
  //  await Hive.deleteBoxFromDisk('todos'); //to be deleted in prod
  await Hive.openBox<Todolist>('todos');
  await Hive.openBox<Note>('notes');
  await Hive.openBox<PrivNotes>('priv_notes');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
      GoRoute(
        path: '/todolist_page',
        builder: (BuildContext context, GoRouterState state) {
          return const TodolistPage();
        },
      ),
      GoRoute(
        path: '/todos_page',
        builder: (BuildContext context, GoRouterState state) {
          return const TodosPage();
        },
      ),
      GoRoute(
        path: '/notes_page',
        builder: (BuildContext context, GoRouterState state) {
          return const NotesPage();
        },
      ),
      GoRoute(
        path: '/private_notes_list',
        builder: (BuildContext context, GoRouterState state) {
          return const PrivateNotesList();
        },
      ),
      GoRoute(
        path: '/private_notes',
        builder: (BuildContext context, GoRouterState state) {
          return const PrivateNotes();
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.darkTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
