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

const String createTasksTableIndexes = '''
  CREATE INDEX idx_tasks_day ON tasks(day);
  CREATE INDEX idx_tasks_start_time ON tasks(startTime);
''';

const String createSubtasksTable = '''
  CREATE TABLE subtasks (
    id TEXT PRIMARY KEY,
    taskId TEXT REFERENCES tasks(id) ON DELETE CASCADE,
    title TEXT,
    isDone INTEGER
  )
''';

const String createSubtasksTableIndexes = '''
  CREATE INDEX idx_subtasks_task_id ON subtasks(taskId);
''';

const String createNotificationsTable = '''
  CREATE TABLE notifications (
    id INTEGER PRIMARY KEY,
    taskId TEXT REFERENCES tasks(id) ON DELETE CASCADE,
    triggerType TEXT, 
    triggerValue INTEGER, 
    scheduledTime TEXT
  )
''';

const String createHabitsTable = '''
  CREATE TABLE habits (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL, 
    isSelected INTEGER NOT NULL DEFAULT 1,
    isCustom INTEGER NOT NULL DEFAULT 0, 
    currentStreak INTEGER NOT NULL DEFAULT 0,
    lastCompletedDate TEXT       
)
''';
