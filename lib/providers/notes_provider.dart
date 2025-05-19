import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences.dart';
import '../models/note.dart';

class NotesProvider with ChangeNotifier {
  static const String _notesKey = 'notes';
  List<Note> _notes = [];
  late SharedPreferences _prefs;

  List<Note> get notes => List.unmodifiable(_notes);

  NotesProvider() {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    _prefs = await SharedPreferences.getInstance();
    final notesJson = _prefs.getStringList(_notesKey) ?? [];
    _notes = notesJson
        .map((noteJson) => Note.fromJson(json.decode(noteJson)))
        .toList();
    notifyListeners();
  }

  Future<void> _saveNotes() async {
    final notesJson = _notes
        .map((note) => json.encode(note.toJson()))
        .toList();
    await _prefs.setStringList(_notesKey, notesJson);
  }

  Future<void> addNote(String title, String content) async {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
      modifiedAt: DateTime.now(),
    );
    _notes.add(note);
    await _saveNotes();
    notifyListeners();
  }

  Future<void> updateNote(String id, String title, String content) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = Note(
        id: id,
        title: title,
        content: content,
        createdAt: _notes[index].createdAt,
        modifiedAt: DateTime.now(),
      );
      await _saveNotes();
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
    await _saveNotes();
    notifyListeners();
  }

  Future<void> deleteAllNotes() async {
    _notes.clear();
    await _saveNotes();
    notifyListeners();
  }
} 