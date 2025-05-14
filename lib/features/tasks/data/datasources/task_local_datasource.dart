import 'dart:ui';

import 'package:anchor/features/tasks/domain/entities/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskLocalDataSource {
  static final TaskLocalDataSource _instance = TaskLocalDataSource._internal();

  factory TaskLocalDataSource() => _instance;

  TaskLocalDataSource._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return _database!;
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT,
        isDone INTEGER,
        day TEXT,
        startTime TEXT,
        duration INTEGER,
        color INTEGER
      )
    ''');
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final maps = await db.query('tasks');

    return maps.map((map) {
      return Task(
        id: map['id'] as String,
        title: map['title'] as String,
        isDone: (map['isDone'] as int) == 1,
        day: DateTime.parse(map['day'] as String),
        startTime: map['startTime'] != null
            ? DateTime.tryParse(map['startTime'] as String)
            : null,
        duration: map['duration'] != null
            ? Duration(minutes: map['duration'] as int)
            : null,
        color: Color(map['color'] as int),
      );
    }).toList();
  }

  Future<void> addTask(Task task) async {
    final db = await database;
    await db.insert('tasks', {
      'id': task.id,
      'title': task.title,
      'isDone': task.isDone ? 1 : 0,
      'day': task.day.toIso8601String(),
      'startTime': task.startTime?.toIso8601String(),
      'duration': task.duration?.inMinutes,
      'color': task.color.toARGB32(),
    });
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      {
        'title': task.title,
        'isDone': task.isDone ? 1 : 0,
        'day': task.day.toIso8601String(),
        'startTime': task.startTime?.toIso8601String(),
        'duration': task.duration?.inMinutes,
        'color': task.color.toARGB32(),
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(String id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
