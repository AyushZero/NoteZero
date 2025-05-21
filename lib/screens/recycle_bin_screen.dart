import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/notes_provider.dart';

class RecycleBinScreen extends StatelessWidget {
  const RecycleBinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycle Bin'),
        actions: [
          Consumer<NotesProvider>(
            builder: (context, notesProvider, child) {
              if (notesProvider.deletedNotes.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Clear Recycle Bin'),
                      content: const Text(
                        'Are you sure you want to permanently delete all notes in the recycle bin? This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            notesProvider.clearRecycleBin();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Recycle bin cleared'),
                              ),
                            );
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          final deletedNotes = notesProvider.deletedNotes;
          if (deletedNotes.isEmpty) {
            return const Center(
              child: Text(
                'No deleted notes',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: deletedNotes.length,
            itemBuilder: (context, index) {
              final note = deletedNotes[index];
              return Dismissible(
                key: Key(note.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete_forever, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 16),
                  child: const Icon(Icons.restore, color: Colors.white),
                ),
                direction: DismissDirection.horizontal,
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Permanently Delete'),
                        content: const Text(
                          'Are you sure you want to permanently delete this note? This action cannot be undone.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return true;
                },
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    notesProvider.permanentlyDeleteNote(note.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Note permanently deleted')),
                    );
                  } else {
                    notesProvider.restoreNote(note.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Note restored')),
                    );
                  }
                },
                child: ListTile(
                  title: Text(
                    note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    DateFormat('MMM d, y HH:mm').format(note.modifiedAt),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 