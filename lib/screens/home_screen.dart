import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/notes_provider.dart';
import '../providers/theme_provider.dart';
import 'note_screen.dart';
import 'recycle_bin_screen.dart';
import 'package:notezero/widgets/app_icon.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecycleBinScreen(),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'NoteZero',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your minimalist notes',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor.withAlpha(179),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.note_add,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'New Note',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
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
                    leading: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      'Recycle Bin',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    trailing: notesProvider.deletedNotes.isNotEmpty
                        ? Text(
                            '${notesProvider.deletedNotes.length}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor.withAlpha(179),
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
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      themeProvider.themeMode == ThemeMode.dark
                          ? 'Light Mode'
                          : 'Dark Mode',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
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
            return Center(
              child: Text(
                'No notes yet.\nCreate one from the menu.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor.withAlpha(179),
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
                  color: Theme.of(context).primaryColor.withAlpha(26),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.delete,
                    color: Theme.of(context).primaryColor,
                  ),
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
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        note.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('MMM d, y HH:mm').format(note.modifiedAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor.withAlpha(179),
                        ),
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
                    Divider(
                      color: Theme.of(context).dividerColor,
                      height: 1,
                    ),
                  ],
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