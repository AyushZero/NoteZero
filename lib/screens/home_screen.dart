import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/notes_provider.dart';
import '../providers/theme_provider.dart';
import 'note_screen.dart';
import 'recycle_bin_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteZero'),
      ),
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'NoteZero',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your minimalist notes',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.note_add),
                title: const Text('New Note'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NoteScreen(),
                    ),
                  );
                },
              ),
              Consumer<NotesProvider>(
                builder: (context, notesProvider, child) {
                  return ListTile(
                    leading: const Icon(Icons.delete_outline),
                    title: const Text('Recycle Bin'),
                    trailing: notesProvider.deletedNotes.isNotEmpty
                        ? Text(
                            '${notesProvider.deletedNotes.length}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          )
                        : null,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecycleBinScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return ListTile(
                    leading: Icon(
                      themeProvider.themeMode == ThemeMode.dark
                          ? Icons.light_mode
                          : Icons.dark_mode,
                    ),
                    title: Text(
                      themeProvider.themeMode == ThemeMode.dark
                          ? 'Light Mode'
                          : 'Dark Mode',
                    ),
                    onTap: () {
                      themeProvider.toggleTheme();
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          final notes = notesProvider.notes;
          if (notes.isEmpty) {
            return const Center(
              child: Text(
                'No notes yet.\nCreate one from the menu.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Dismissible(
                key: Key(note.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  notesProvider.deleteNote(note.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Note moved to recycle bin'),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          notesProvider.undoDelete();
                        },
                      ),
                    ),
                  );
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteScreen(note: note),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 