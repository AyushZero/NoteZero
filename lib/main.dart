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
              primaryColor: const Color(0xFF9C27B0),
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(color: Color(0xFF9C27B0)),
                titleTextStyle: TextStyle(
                  color: Color(0xFF9C27B0),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
              dividerTheme: const DividerThemeData(
                color: Color(0xFF9C27B0),
                thickness: 1,
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              primaryColor: const Color(0xFF7B1FA2),
              scaffoldBackgroundColor: const Color(0xFF121212),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF121212),
                elevation: 0,
                iconTheme: IconThemeData(color: Color(0xFF7B1FA2)),
                titleTextStyle: TextStyle(
                  color: Color(0xFF7B1FA2),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
              dividerTheme: const DividerThemeData(
                color: Color(0xFF7B1FA2),
                thickness: 1,
              ),
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
