import 'package:flutter/foundation.dart';
import '../models/note.dart';
import '../database/database_helper.dart';
import '../constants/app_constants.dart';

class NotesProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Note> _notes = [];
  bool _isDarkMode = false;
  bool _isLoading = false;

  List<Note> get notes => _notes;
  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;

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
      await _dbHelper.insertNote(note);
      await loadNotes();
    } catch (e) {
      debugPrint('${AppConstants.errorAddingNote}$e');
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await _dbHelper.updateNote(note);
      await loadNotes();
    } catch (e) {
      debugPrint('${AppConstants.errorUpdatingNote}$e');
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await _dbHelper.deleteNote(id);
      await loadNotes();
    } catch (e) {
      debugPrint('${AppConstants.errorDeletingNote}$e');
    }
  }

  Future<void> deleteAllNotes() async {
    try {
      await _dbHelper.deleteAllNotes();
      await loadNotes();
    } catch (e) {
      debugPrint('${AppConstants.errorDeletingAllNotes}$e');
    }
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
} 