import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/notes_provider.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'NoteZero',
            themeMode: themeProvider.themeMode,
            theme: ThemeData.light().copyWith(
              primaryColor: Colors.blue,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blue,
                elevation: 0,
              ),
              colorScheme: const ColorScheme.light(
                primary: Colors.blue,
                secondary: Colors.blueAccent,
                surface: Colors.white,
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: Colors.black,
              scaffoldBackgroundColor: const Color(0xFF121212),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                elevation: 0,
              ),
              colorScheme: ColorScheme.dark(
                primary: Colors.white,
                secondary: Colors.grey[400]!,
                surface: const Color(0xFF1E1E1E),
              ),
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
