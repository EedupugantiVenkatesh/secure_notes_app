import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../database/database_helper.dart';
import '../constants/app_constants.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  bool _isFirstLaunch = true;
  bool _isAuthenticated = false;

  bool get isFirstLaunch => _isFirstLaunch;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkFirstLaunch() async {
    final hasPin = await _storage.read(key: AppConstants.pinKey) != null;
    _isFirstLaunch = !hasPin;
    notifyListeners();
  }

  Future<void> setPin(String pin) async {
    await _storage.write(key: AppConstants.pinKey, value: pin);
    _isFirstLaunch = false;
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<bool> verifyPin(String pin) async {
    final storedPin = await _storage.read(key: AppConstants.pinKey);
    final isValid = storedPin == pin;
    _isAuthenticated = isValid;
    notifyListeners();
    return isValid;
  }

  Future<void> resetPin() async {
    // Delete all notes from the database
    await DatabaseHelper().deleteAllNotes();
    
    // Delete the PIN
    await _storage.delete(key: AppConstants.pinKey);
    
    // Reset state
    _isFirstLaunch = true;
    _isAuthenticated = false;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<bool> isPinSet() async {
    final storedPin = await _storage.read(key: AppConstants.pinKey);
    return storedPin != null;
  }
} 