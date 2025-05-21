import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NotesProvider with ChangeNotifier {
  static const String _notesKey = 'notes';
  List<Note> _notes = [];
  late SharedPreferences _prefs;
  Note? _lastDeletedNote;

  List<Note> get notes => List.unmodifiable(_notes.where((note) => !note.isDeleted).toList());
  List<Note> get deletedNotes => List.unmodifiable(_notes.where((note) => note.isDeleted).toList());
  Note? get lastDeletedNote => _lastDeletedNote;

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
        isDeleted: _notes[index].isDeleted,
      );
      await _saveNotes();
      notifyListeners();
    }
  }

  Future<void> deleteNote(String id) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _lastDeletedNote = _notes[index];
      _notes[index] = Note(
        id: _notes[index].id,
        title: _notes[index].title,
        content: _notes[index].content,
        createdAt: _notes[index].createdAt,
        modifiedAt: DateTime.now(),
        isDeleted: true,
      );
      await _saveNotes();
      notifyListeners();
    }
  }

  Future<void> undoDelete() async {
    if (_lastDeletedNote != null) {
      final index = _notes.indexWhere((note) => note.id == _lastDeletedNote!.id);
      if (index != -1) {
        _notes[index] = Note(
          id: _lastDeletedNote!.id,
          title: _lastDeletedNote!.title,
          content: _lastDeletedNote!.content,
          createdAt: _lastDeletedNote!.createdAt,
          modifiedAt: DateTime.now(),
          isDeleted: false,
        );
        _lastDeletedNote = null;
        await _saveNotes();
        notifyListeners();
      }
    }
  }

  Future<void> restoreNote(String id) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = Note(
        id: _notes[index].id,
        title: _notes[index].title,
        content: _notes[index].content,
        createdAt: _notes[index].createdAt,
        modifiedAt: DateTime.now(),
        isDeleted: false,
      );
      await _saveNotes();
      notifyListeners();
    }
  }

  Future<void> permanentlyDeleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
    await _saveNotes();
    notifyListeners();
  }

  Future<void> clearRecycleBin() async {
    _notes.removeWhere((note) => note.isDeleted);
    await _saveNotes();
    notifyListeners();
  }
} 