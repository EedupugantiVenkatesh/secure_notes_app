class AppConstants {
  // App Info
  static const String appName = 'Secure Notes';
  
  // Database
  static const String databaseName = 'secure_notes.db';
  static const int databaseVersion = 1;
  static const String notesTable = 'notes';
  
  // Database Columns
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnContent = 'content';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';
  
  // PIN
  static const String pinKey = 'user_pin';
  static const int pinLength = 4;
  
  // Theme
  static const String themeKey = 'is_dark_mode';
  
  // Messages
  static const String emptyNotesMessage = 'No notes yet. Tap + to create one!';
  static const String pinRequiredMessage = 'Please enter a PIN';
  static const String pinLengthMessage = 'PIN must be 4 digits';
  static const String pinNumbersOnlyMessage = 'PIN must contain only numbers';
  static const String pinMismatchMessage = 'PINs do not match';
  static const String invalidPinMessage = 'Invalid PIN';
  static const String pinSetSuccessMessage = 'PIN set successfully';
  static const String pinResetSuccessMessage = 'PIN reset successfully';
  static const String noteDeletedMessage = 'Note deleted successfully';
  static const String deleteNoteConfirmationMessage = 'Are you sure you want to delete this note?';
  static const String forgotPinWarningMessage = 'Resetting your PIN will delete all your notes. This action cannot be undone. Are you sure you want to continue?';
  static const String errorMessage = 'Error: ';
  static const String titleRequiredMessage = 'Please enter a title';
  static const String contentRequiredMessage = 'Please enter some content';
  static const String pinValidationMessage = 'Please enter a valid 4-digit PIN';
  static const String pinInvalidMessage = 'Invalid PIN. Please try again.';
  
  // Labels
  static const String enterPinLabel = 'Enter 4-digit PIN';
  static const String confirmPinLabel = 'Confirm PIN';
  static const String myNotesLabel = 'My Notes';
  static const String lastUpdatedLabel = 'Last updated:';
  static const String titleLabel = 'Title';
  static const String contentLabel = 'Content';
  static const String pinLabel = 'PIN';
  static const String newNoteLabel = 'New Note';
  static const String editNoteLabel = 'Edit Note';
  static const String addNoteLabel = 'Add Note';
  static const String saveChangesLabel = 'Save Changes';
  static const String setPinLabel = 'Set PIN';
  static const String verifyPinLabel = 'Verify PIN';
  static const String resetPinLabel = 'Reset PIN';
  static const String setUpPinLabel = 'Set Up PIN';
  static const String deleteNoteLabel = 'Delete Note';
  static const String warningLabel = 'Warning: Resetting your PIN will delete all your notes.';
  
  // Actions
  static const String editAction = 'Edit';
  static const String deleteAction = 'Delete';
  static const String cancelAction = 'Cancel';
  static const String resetAction = 'Reset PIN';
  static const String setPinAction = 'Set PIN';
  static const String verifyPinAction = 'Verify PIN';
  static const String forgotPinAction = 'Forgot PIN?';
  static const String saveAction = 'Save';
  
  // Errors
  static const String errorLoadingNotes = 'Error loading notes: ';
  static const String errorAddingNote = 'Error adding note: ';
  static const String errorUpdatingNote = 'Error updating note: ';
  static const String errorDeletingNote = 'Error deleting note: ';
  static const String errorDeletingAllNotes = 'Error deleting all notes: ';
  
  // UI Constants
  static const double cardElevation = 2.0;
  static const double cardBorderRadius = 12.0;
  static const double cardHorizontalMargin = 8.0;
  static const double cardVerticalMargin = 4.0;
  static const double contentPadding = 16.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double warningFontSize = 16.0;
  static const double titleFontSize = 16.0;
  static const double contentFontSize = 14.0;
  static const double buttonPadding = 16.0;
  static const double loadingIndicatorSize = 20.0;
  static const double loadingIndicatorStrokeWidth = 2.0;
  
  // Animation Durations
  static const int snackbarDurationShort = 2;
  static const int snackbarDurationLong = 3;
  
  // Date Format
  static const String dateFormat = 'dd/MM/yyyy HH:mm';
} 