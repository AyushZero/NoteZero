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
            debugShowCheckedModeBanner: false,
            title: 'NoteZero',
            themeMode: themeProvider.themeMode,
            theme: ThemeData.light().copyWith(
              primaryColor: const Color(0xFF9C27B0), // Light purple
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF9C27B0),
                elevation: 0,
              ),
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF9C27B0),
                secondary: Color(0xFFBA68C8),
                surface: Colors.white,
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Color(0xFF9C27B0),
                foregroundColor: Colors.white,
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: const Color(0xFF7B1FA2), // Darker purple
              scaffoldBackgroundColor: const Color(0xFF121212),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF7B1FA2),
                elevation: 0,
              ),
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF7B1FA2),
                secondary: Color(0xFF9C27B0),
                surface: Color(0xFF1E1E1E),
              ),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Color(0xFF7B1FA2),
                foregroundColor: Colors.white,
              ),
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
