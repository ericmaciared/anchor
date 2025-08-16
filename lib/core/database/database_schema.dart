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

const String insertTestHabits = '''
INSERT INTO habits (id, name, isSelected, isCustom, currentStreak, lastCompletedDate) VALUES
('habit-001', 'Morning Meditation', 1, 0, 0, NULL),
('habit-002', 'Drink Water', 1, 0, 1, datetime('now', 'localtime')),
('habit-003', 'Read 30 Minutes', 1, 0, 3, datetime('now', '-1 day', 'localtime')),
('habit-004', 'Exercise', 1, 0, 7, datetime('now', 'localtime')),
('habit-005', 'Journal Writing', 1, 0, 5, datetime('now', '-3 days', 'localtime')),
('habit-006', 'Cold Shower', 1, 0, 15, datetime('now', '-1 day', 'localtime')),
('habit-007', 'Practice Guitar', 1, 0, 30, datetime('now', 'localtime')),
('habit-008', 'Stretching', 1, 0, 1, datetime('now', '-1 day', 'localtime')),
('habit-009', 'Learn Spanish', 1, 1, 4, datetime('now', '-2 days', 'localtime')),
('habit-010', 'Take Vitamins', 1, 0, 10, datetime('now', '-1 week', 'localtime')),
('habit-011', 'Make Bed', 1, 0, 1, datetime('now', 'localtime')),
('habit-012', 'Disabled Habit', 0, 0, 3, datetime('now', '-1 day', 'localtime'));
''';
