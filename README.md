# Secure Notes App

A Flutter application for managing personal text notes with PIN protection. This app provides a secure way to store and manage your notes with a 4-digit PIN authentication system.

# APK Download

[📱 Download APK](https://github.com/EedupugantiVenkatesh/secure_notes_app/releases/download/secureNotes/app-release.apk)

## Features

- 🔐 4-digit PIN protection
- 📝 Create, edit, and delete notes
- 🌓 Dark mode support
- 🔄 Pull-to-refresh functionality
- ⚡ Smooth animations and transitions
- 📱 Responsive design
- 🔒 Secure data storage
- 🔑 PIN reset functionality (with data wipe)

## Screenshots/Videos

https://github.com/user-attachments/assets/54873cb0-a6e7-4cdf-8322-5d9b5ddf3bfe

## Setup Instructions

1. **Prerequisites**

   - Flutter SDK (latest stable version)
   - Android Studio / VS Code
   - Git

2. **Installation**
   ```bash
   # Clone the repository
   git clone https://github.com/EedupugantiVenkatesh/secure_notes_app.git
   
   # Navigate to project directory
   cd secure_notes_app
   
   # Get dependencies
   flutter pub get
   
   # Run the app
   flutter run
   ```

3. **Building the app**
   ```bash
   # For Android
   flutter build apk
   
   # For iOS
   flutter build ios
   ```

## Project Structure

```
lib/
├── database/
│   └── database_helper.dart
├── models/
│   └── note.dart
├── providers/
│   ├── auth_provider.dart
│   └── notes_provider.dart
├── screens/
│   ├── notes_list_screen.dart
│   ├── note_edit_screen.dart
│   ├── pin_setup_screen.dart
│   └── pin_verification_screen.dart
└── main.dart
```

## Dependencies

The project uses the following packages:

- `provider`: ^6.0.5 - For state management
- `sqflite`: ^2.3.0 - For local database storage
- `path`: ^1.8.3 - For database path handling
- `flutter_secure_storage`: ^9.0.0 - For storing PIN Securely
- `flutter_slidable`: ^3.0.0 - For swipe actions on notes
- `intl`: ^0.20.2- For Date formatting


## Design Decisions

1. **State Management**
   - Used Provider for state management due to its simplicity and efficiency
   - Separate providers for authentication and notes management

2. **Data Storage**
   - SQLite database for notes storage
   - SharedPreferences for PIN storage
   - Local storage for better privacy and offline access

3. **Security**
   - 4-digit PIN authentication
   - Data wipe on PIN reset
   - No cloud synchronization to maintain privacy

4. **UI/UX**
   - Material Design 3
   - Dark mode support
   - Swipe actions for quick access
   - Pull-to-refresh for data updates
   - Responsive layout



