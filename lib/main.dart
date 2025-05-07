import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/notes_provider.dart';
import 'screens/pin_screen.dart';
import 'screens/notes_list_screen.dart';
import 'constants/app_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
      ],
      child: Consumer<NotesProvider>(
        builder: (context, notesProvider, _) {
          return MaterialApp(
            title: AppConstants.appName,
            theme: ThemeData.light(),
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData.dark(),
            themeMode: notesProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    await context.read<AuthProvider>().checkFirstLaunch();
  }

  Future<void> _handlePinVerified() async {
    // Load notes after PIN verification
    await context.read<NotesProvider>().loadNotes();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NotesListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isFirstLaunch) {
          return PinScreen(
            isSetup: true,
            onPinVerified: _handlePinVerified,
          );
        } else if (!authProvider.isAuthenticated) {
          return PinScreen(
            isSetup: false,
            onPinVerified: _handlePinVerified,
          );
        } else {
          return const NotesListScreen();
        }
      },
    );
  }
}
