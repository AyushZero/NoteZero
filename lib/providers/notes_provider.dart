import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/note.dart';

class NotesProvider with ChangeNotifier {
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  NotesProvider() {
    loadNotes();
  }

  Future<void> loadNotes() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/notes.json');
      
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> jsonData = json.decode(content);
        _notes = jsonData.map((item) => Note.fromJson(item)).toList();
        _notes.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading notes: $e');
    }
  }

  Future<void> saveNotes() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/notes.json');
      final data = _notes.map((note) => note.toJson()).toList();
      await file.writeAsString(json.encode(data));
    } catch (e) {
      debugPrint('Error saving notes: $e');
    }
  }

  Future<void> addNote(String title, String content) async {
    final note = Note(title: title, content: content);
    _notes.insert(0, note);
    notifyListeners();
    await saveNotes();
  }

  Future<void> updateNote(String id, String title, String content) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index].title = title;
      _notes[index].content = content;
      _notes[index].modifiedAt = DateTime.now();
      _notes.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
      notifyListeners();
      await saveNotes();
    }
  }

  Future<void> deleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
    await saveNotes();
  }
} 