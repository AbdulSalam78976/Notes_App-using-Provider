// notes_provider.dart
// Provides state management for the Notes App using ChangeNotifier.

import 'package:flutter/material.dart';
import 'package:notes_app_using_provider/models/note.dart';

/// NotesProvider manages the list of notes and notifies listeners on changes.
class NotesProvider extends ChangeNotifier {
  /// The list of all notes.
  List<Note> notes = [];

  /// Adds a new note and notifies listeners.
  void addNote(Note note) {
    notes.add(note);
    notifyListeners();
  }

  /// Removes a note and notifies listeners.
  void removeNote(Note note) {
    notes.remove(note);
    notifyListeners();
  }

  /// Updates an existing note (by id) and notifies listeners.
  void updateNote(Note note) {
    int index = notes.indexOf(note);
    if (index != -1) {
      notes[index] = note;
      notifyListeners();
    }
  }

  /// Returns the note with the given id.
  Note getNoteById(String id) {
    return notes.firstWhere((note) => note.id == id);
  }
}
