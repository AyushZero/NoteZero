import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';

class NoteScreen extends StatefulWidget {
  final Note? note;

  const NoteScreen({super.key, this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late FocusNode _contentFocusNode;
  bool _isEdited = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _contentFocusNode = FocusNode();

    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);

    // Auto-focus content field for new notes
    if (widget.note == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _contentFocusNode.requestFocus();
      });
    }
  }

  void _onTextChanged() {
    if (!_isEdited) {
      setState(() => _isEdited = true);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (!_isEdited) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('Do you want to save your changes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Discard'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == null) return false;
    if (result) {
      _saveNote();
    }
    return true;
  }

  String _generateTitleFromContent(String content) {
    if (content.isEmpty) return 'Untitled';
    
    // Split content into words and take first 5 words
    final words = content.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return 'Untitled';
    
    // Take up to 5 words or all words if less than 5
    final titleWords = words.take(5).join(' ');
    
    // If title is longer than 30 characters, truncate it
    if (titleWords.length > 30) {
      return '${titleWords.substring(0, 27)}...';
    }
    
    return titleWords;
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    
    if (title.isEmpty && content.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final finalTitle = title.isEmpty ? _generateTitleFromContent(content) : title;
    
    if (widget.note != null) {
      notesProvider.updateNote(
        widget.note!.id,
        finalTitle,
        content,
      );
    } else {
      notesProvider.addNote(
        finalTitle,
        content,
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveNote,
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
              ),
              const Divider(),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  focusNode: _contentFocusNode,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Start typing...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 