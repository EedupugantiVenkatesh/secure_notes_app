import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      AppConstants.columnId: id,
      AppConstants.columnTitle: title,
      AppConstants.columnContent: content,
      AppConstants.columnCreatedAt: createdAt.toIso8601String(),
      AppConstants.columnUpdatedAt: updatedAt.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map[AppConstants.columnId],
      title: map[AppConstants.columnTitle],
      content: map[AppConstants.columnContent],
      createdAt: DateTime.parse(map[AppConstants.columnCreatedAt]),
      updatedAt: DateTime.parse(map[AppConstants.columnUpdatedAt]),
    );
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get formattedUpdatedAt {
    return DateFormat(AppConstants.dateFormat).format(updatedAt);
  }
} 