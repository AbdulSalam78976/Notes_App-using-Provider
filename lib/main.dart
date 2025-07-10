// main.dart
// Entry point of the Notes App. Sets up the app theme and provider.

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_app_using_provider/apptheme.dart';
import 'package:notes_app_using_provider/models/note.dart';
import 'package:notes_app_using_provider/screens/homescreen.dart';
import 'package:notes_app_using_provider/provider/notes_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  // Initialize Hive
  await Hive.initFlutter();
  // Register the Note adapter
  Hive.registerAdapter(NoteAdapter());
  // Open the notes box
  await Hive.openBox<Note>('notesBox');

  // Start the app
  runApp(const MyApp());
}

/// Root widget of the Notes App.
/// Sets up the [ChangeNotifierProvider] for [NotesProvider].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotesProvider(),

      child: MaterialApp(
        title: 'Flutter Notes App',
        theme: AppTheme.darkThemeMode,
        home: HomeScreen(),
      ),
    );
  }
}
