const String createTasksTable = '''
  CREATE TABLE tasks (
    id TEXT PRIMARY KEY,
    title TEXT,
    isDone INTEGER,
    day TEXT,
    startTime TEXT,
    duration INTEGER,
    color INTEGER,
    iconCodePoint INTEGER
  )
''';

const String createSubtasksTable = '''
  CREATE TABLE subtasks (
    id TEXT PRIMARY KEY,
    taskId TEXT REFERENCES tasks(id) ON DELETE CASCADE,
    title TEXT,
    isDone INTEGER
  )
''';
