import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String createTasksTable = '''
CREATE TABLE tasks (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  category TEXT NOT NULL,
  start_time TEXT NOT NULL,
  duration_minutes INTEGER NOT NULL,
  icon_code_point INTEGER,
  completed INTEGER NOT NULL
);
''';

const String createHabitsTable = '''
CREATE TABLE habits (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  icon_code_point INTEGER NOT NULL,
  type TEXT NOT NULL,
  counter INTEGER NOT NULL,
  streak INTEGER NOT NULL,
  last_done TEXT
);
''';

class DatabaseHelper {
  static Database? _database;
  static const _dbName = 'anchor.db';
  static const _dbVersion = 1;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute(createTasksTable);
        await db.execute(createHabitsTable);
      },
    );
  }
}
