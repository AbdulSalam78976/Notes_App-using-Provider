// homescreen.dart
// Main screen of the Notes App. Displays, adds, edits, and deletes notes.

import 'package:flutter/material.dart';
import 'package:notes_app_using_provider/app_pallete.dart';
import 'package:notes_app_using_provider/models/note.dart';
import 'package:notes_app_using_provider/provider/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

/// HomeScreen displays the list of notes and provides UI for adding/editing/deleting notes.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    print('HomeScreen.createState');
    return _HomeScreenState();
  }
}

/// State for [HomeScreen]. Manages text controllers and dialog logic.
class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  /// Builds the main UI: AppBar, notes grid, and FAB.
  @override
  Widget build(BuildContext context) {
    print('_HomeScreenState.build');
    return Scaffold(
      appBar: AppBar(title: const Text("Notes App")),
      body: Consumer<NotesProvider>(
        builder:
            (BuildContext context, NotesProvider notesProvider, Widget? child) {
              print('Consumer<NotesProvider> builder called');
              if (notesProvider.notes.isEmpty) {
                return Center(child: Text("No notes yet."));
              }
              // Grid of note cards
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600
                        ? 3
                        : 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: notesProvider.notes.length,
                  itemBuilder: (context, index) {
                    print('Note card build for index: ' + index.toString());
                    Note note = notesProvider.notes[index];
                    // Note card UI
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: AppPallete.gradient3,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    note.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                      onPressed: () =>
                                          _showEditNoteDialog(context, note),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        notesProvider.removeNote(note);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Note deleted successfully",
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              note.content,
                              style: const TextStyle(fontSize: 15),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddNoteDialog(context),
      ),
    );
  }

  /// Shows a dialog to add a new note.
  void _showAddNoteDialog(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);

    // we have not used consumer widget here because we want to show the dialog only once.And we want to show the dialog only when the user clicks the add button.
    //consumer widget is used to listen to the changes in the notesProvider and rebuild the widget when the notesProvider changes.
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Note"),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: "Title"),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: "Description"),
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String title = _titleController.text;
                String desc = _descController.text;
                if (title.isNotEmpty && desc.isNotEmpty) {
                  final id = const Uuid().v4();
                  notesProvider.addNote(
                    Note(id: id, title: title, content: desc),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Note added successfully")),
                  );
                  _titleController.clear();
                  _descController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  /// Shows a dialog to edit an existing note.
  void _showEditNoteDialog(BuildContext context, Note note) {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final TextEditingController editTitleController = TextEditingController(
      text: note.title,
    );
    final TextEditingController editDescController = TextEditingController(
      text: note.content,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Note"),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: editTitleController,
                    decoration: const InputDecoration(labelText: "Title"),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: editDescController,
                    decoration: const InputDecoration(labelText: "Description"),
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String newTitle = editTitleController.text;
                String newDesc = editDescController.text;
                if (newTitle.isNotEmpty && newDesc.isNotEmpty) {
                  notesProvider.updateNote(
                    Note(id: note.id, title: newTitle, content: newDesc),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Note updated successfully")),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
