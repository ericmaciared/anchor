const String createTasksTable = '''
  CREATE TABLE tasks (
    id TEXT PRIMARY KEY,
    title TEXT,
    isDone INTEGER,
    day TEXT,
    startTime TEXT,
    duration INTEGER,
    color INTEGER,
    iconCodePoint INTEGER,
    parentTaskId TEXT REFERENCES tasks(id) ON DELETE CASCADE
  )
''';
