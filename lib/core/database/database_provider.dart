import 'package:anchor/core/database/database_schema.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final databaseProvider = FutureProvider<Database>((ref) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'anchor.db');

  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute(createTasksTable);
      await db.execute(createTasksTableIndexes);
      await db.execute(createSubtasksTable);
      await db.execute(createSubtasksTableIndexes);
      await db.execute(createNotificationsTable);
      await db.execute(createHabitsTable);
      await db.execute(populateHabitsTable);
    },
  );
});
