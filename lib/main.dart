import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/note.dart';
import 'screens/home_screen.dart';
import 'providers/notes_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotesProvider(),
      child: MaterialApp(
        title: 'NoteZero',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.grey[900],
          scaffoldBackgroundColor: const Color(0xFF1E1E1E),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey[900],
            elevation: 0,
          ),
          colorScheme: ColorScheme.dark(
            primary: Colors.grey[200]!,
            secondary: Colors.grey[600]!,
            surface: Colors.grey[850]!,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
