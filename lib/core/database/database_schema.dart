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

const String populateHabitsTable = '''
  INSERT INTO habits (id, name, isSelected, isCustom, currentStreak, lastCompletedDate) VALUES
    ('pre-habit-1-workout', 'Work out', 1, 0, 7, '2025-06-25T08:00:00.000'),
    ('pre-habit-2-water', 'Drink 8 glasses of water', 1, 0, 15, '2025-06-25T14:30:00.000'),
    ('pre-habit-3-read', 'Read for 30 mins', 0, 0, 0, NULL),
    ('pre-habit-4-meditate', 'Meditate for 10 mins', 1, 0, 3, '2025-06-25T07:00:00.000'),
    ('pre-habit-5-sun', 'Be in the sun for 15 mins', 1, 0, 1, '2025-06-25T11:00:00.000')
''';
