import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/note.dart';
import '../database/database_helper.dart';
import '../constants/app_constants.dart';

class NotesProvider with ChangeNotifier {
  final _dbHelper = DatabaseHelper();
  final _storage = const FlutterSecureStorage();
  List<Note> _notes = [];
  bool _isDarkMode = false;
  bool _isLoading = false;

  List<Note> get notes => _notes;
  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;

  NotesProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final themeValue = await _storage.read(key: AppConstants.themeKey);
    _isDarkMode = themeValue == 'true';
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _storage.write(key: AppConstants.themeKey, value: _isDarkMode.toString());
    notifyListeners();
  }

  Future<void> loadNotes() async {
    try {
      _isLoading = true;
      notifyListeners();

      _notes = await _dbHelper.getNotes();
    } catch (e) {
      debugPrint('${AppConstants.errorLoadingNotes}$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNote(Note note) async {
    try {
      final id = await _dbHelper.insertNote(note);
      note = note.copyWith(id: id);
      _notes.add(note);
      notifyListeners();
    } catch (e) {
      debugPrint('${AppConstants.errorAddingNote}$e');
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await _dbHelper.updateNote(note);
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = note;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('${AppConstants.errorUpdatingNote}$e');
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await _dbHelper.deleteNote(id);
      _notes.removeWhere((note) => note.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('${AppConstants.errorDeletingNote}$e');
    }
  }

  Future<void> deleteAllNotes() async {
    try {
      await _dbHelper.deleteAllNotes();
      _notes.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('${AppConstants.errorDeletingAllNotes}$e');
    }
  }
} 