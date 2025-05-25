import 'package:anchor/core/database/database_schema.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final databaseProvider = Provider<Future<Database>>((ref) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'tasks.db');

  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute(createTasksTable);
    },
  );
});
