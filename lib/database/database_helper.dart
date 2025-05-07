import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';
import '../constants/app_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), AppConstants.databaseName);
    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.notesTable}(
        ${AppConstants.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.columnTitle} TEXT NOT NULL,
        ${AppConstants.columnContent} TEXT NOT NULL,
        ${AppConstants.columnCreatedAt} TEXT NOT NULL,
        ${AppConstants.columnUpdatedAt} TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert(AppConstants.notesTable, note.toMap());
  }

  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.notesTable,
      orderBy: '${AppConstants.columnUpdatedAt} DESC',
    );

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      AppConstants.notesTable,
      note.toMap(),
      where: '${AppConstants.columnId} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      AppConstants.notesTable,
      where: '${AppConstants.columnId} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllNotes() async {
    final db = await database;
    return await db.delete(AppConstants.notesTable);
  }
} 