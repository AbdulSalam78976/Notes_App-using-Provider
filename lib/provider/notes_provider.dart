import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app_using_provider/models/note.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  NotesProvider() {
    _loadNotesFromHive(); // Load on initialization
  }

  void _loadNotesFromHive() {
    final box = Hive.box<Note>('notesBox');
    _notes = box.values.toList();
    notifyListeners();
  }

  void addNote(Note note) {
    final box = Hive.box<Note>('notesBox');
    box.put(note.id, note); // Save with custom ID
    _notes = box.values.toList(); // Reload from box
    notifyListeners();
  }

  void removeNote(Note note) {
    final box = Hive.box<Note>('notesBox');
    box.delete(note.id);
    _notes = box.values.toList();
    notifyListeners();
  }

  void updateNote(Note note) {
    final box = Hive.box<Note>('notesBox');
    box.put(note.id, note);
    _notes = box.values.toList();
    notifyListeners();
  }

  Note? getNoteById(String id) {
    final box = Hive.box<Note>('notesBox');
    return box.get(id);
  }
}
