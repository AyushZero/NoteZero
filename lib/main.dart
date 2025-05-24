import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/notes_provider.dart';
import 'providers/theme_provider.dart';

// Extend ThemeMode to include blue theme
extension ThemeModeExtension on ThemeMode {
  static const ThemeMode blue = ThemeMode(2);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _getThemeForMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return ThemeData.light().copyWith(
          primaryColor: const Color(0xFF9C27B0),
          scaffoldBackgroundColor: Colors.white,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black87),
            bodyMedium: TextStyle(color: Colors.black87),
            titleLarge: TextStyle(color: Colors.black87),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Color(0xFFD09CDA)),
            titleTextStyle: TextStyle(
              color: Color(0xFFAF85B6),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFA268AC),
            secondary: Color(0xFFBA68C8),
            surface: Colors.white,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFFAD5CBC),
            foregroundColor: Colors.white,
          ),
          dividerTheme: const DividerThemeData(
            color: Color(0xFF270133),
            thickness: 1,
          ),
        );
      case ThemeMode.dark:
        return ThemeData.dark().copyWith(
          primaryColor: const Color(0xFFC698D8),
          scaffoldBackgroundColor: const Color(0xFF171717),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
            titleLarge: TextStyle(color: Colors.white),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF121212),
            elevation: 0,
            iconTheme: IconThemeData(color: Color(0xFFD09DE8)),
            titleTextStyle: TextStyle(
              color: Color(0xFFA968C5),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFA665C3),
            secondary: Color(0xFF9C27B0),
            surface: Color(0xFF1E1E1E),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF9D4ABF),
            foregroundColor: Colors.white,
          ),
          dividerTheme: const DividerThemeData(
            color: Color(0xFFAD47DA),
            thickness: 1,
          ),
        );
      case ThemeModeExtension.blue:
        return ThemeData.light().copyWith(
          primaryColor: const Color(0xFF2196F3),
          scaffoldBackgroundColor: const Color(0xFFE3F2FD),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF1565C0)),
            bodyMedium: TextStyle(color: Color(0xFF1565C0)),
            titleLarge: TextStyle(color: Color(0xFF1565C0)),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFBBDEFB),
            elevation: 0,
            iconTheme: IconThemeData(color: Color(0xFF1976D2)),
            titleTextStyle: TextStyle(
              color: Color(0xFF1976D2),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF2196F3),
            secondary: Color(0xFF64B5F6),
            surface: Color(0xFFE3F2FD),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF2196F3),
            foregroundColor: Colors.white,
          ),
          dividerTheme: const DividerThemeData(
            color: Color(0xFF90CAF9),
            thickness: 1,
          ),
        );
      default:
        return ThemeData.light();
    }
  }

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
            theme: _getThemeForMode(themeProvider.themeMode),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
