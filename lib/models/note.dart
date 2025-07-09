// note.dart
// Defines the Note model used in the Notes App.

/// Represents a single note with a unique id, title, and content.
class Note {
  final String id;
  final String title;
  final String content;

  Note({required this.id, required this.title, required this.content});

  /// Notes are considered equal if their id is the same.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
