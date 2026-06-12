import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;
  static Future<Database>? _databaseFuture;
  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _databaseFuture ??= _initDB();
    _database = await _databaseFuture;
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'nityk.db');
    return await openDatabase(
      path,
      version: 5,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
    CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT,
      priority INTEGER NOT NULL DEFAULT 2,
      is_completed INTEGER NOT NULL DEFAULT 0,
      due_date TEXT,
      created_at TEXT NOT NULL,
      completed_at TEXT
    )
  ''');
    await db.execute('''
    CREATE TABLE settings (
      id INTEGER PRIMARY KEY CHECK (id = 1),
      sort_order TEXT NOT NULL DEFAULT 'New->Old',
      dark_mode INTEGER NOT NULL DEFAULT 1,
      use_24h INTEGER NOT NULL DEFAULT 1
    )
  ''');
    await db.execute('''
    CREATE TABLE logs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL DEFAULT '',
      date TEXT NOT NULL,
      started_at TEXT,
      finished_at TEXT,
      duration_seconds INTEGER,
      task_id INTEGER,
      habit_id INTEGER,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
  ''');
    await db.execute('''
    CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      color INTEGER NOT NULL DEFAULT 0xFF2196F3,
      sort_order INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )  
  ''');
    await db.execute('''
    CREATE TABLE tags (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      category_id INTEGER NOT NULL,
      sort_order INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
    )
    ''');
    await db.execute('''
    CREATE TABLE log_tags (
      log_id INTEGER NOT NULL,
      tag_id INTEGER NOT NULL,
      PRIMARY KEY (log_id, tag_id),
      FOREIGN KEY (log_id) REFERENCES logs(id) ON DELETE CASCADE,
      FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
    )
    ''');
    await db.execute('''
    CREATE TABLE task_tags (
      task_id INTEGER NOT NULL,
      tag_id INTEGER NOT NULL,
      PRIMARY KEY (task_id, tag_id),
      FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
      FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
    )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS settings (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        sort_order TEXT NOT NULL DEFAULT 'New->Old',
        dark_mode INTEGER NOT NULL DEFAULT 1,
        use_24h INTEGER NOT NULL DEFAULT 1
      )
    ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        date TEXT NOT NULL,
        started_at TEXT,
        finished_at TEXT,
        duration_seconds INTEGER,
        task_id INTEGER,
        habit_id INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    }
    if (oldVersion < 4) {
      final maps = await db.query('logs', columns: ['id', 'date']);
      for (final map in maps) {
        final oldDate = map['date'] as String;
        if (oldDate.contains('-')) {
          final parts = oldDate.split('-');
          if (parts.length == 3) {
            final newDate = '${parts[2]}${parts[1]}${parts[0]}';
            await db.update(
              'logs',
              {'date': newDate},
              where: 'id = ?',
              whereArgs: [map['id']],
            );
          }
        }
      }
    }
    if (oldVersion < 5) {
      await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color INTEGER NOT NULL DEFAULT 0xFF2196F3,
        sort_order INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
      await db.execute('''
      CREATE TABLE tags (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        sort_order INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
      )
    ''');
      await db.execute('''
      CREATE TABLE log_tags (
        log_id INTEGER NOT NULL,
        tag_id INTEGER NOT NULL,
        PRIMARY KEY (log_id, tag_id),
        FOREIGN KEY (log_id) REFERENCES logs(id) ON DELETE CASCADE,
        FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
      )
    ''');
      await db.execute('''
      CREATE TABLE task_tags (
        task_id INTEGER NOT NULL,
        tag_id INTEGER NOT NULL,
        PRIMARY KEY (task_id, tag_id),
        FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
        FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
      )
    ''');
    }
  }

  // tasks
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final maps = await db.query('tasks', orderBy: 'created_at DESC');
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> toggleComplete(int id) async {
    final db = await database;
    final maps = await db.query('tasks', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return;
    final task = Task.fromMap(maps.first);
    await db.update(
      'tasks',
      {
        'is_completed': task.isCompleted ? 0 : 1,
        'completed_at': task.isCompleted
            ? null
            : DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // settings
  Future<Settings> getSettings() async {
    final db = await database;
    final maps = await db.query('settings', where: 'id = 1');
    if (maps.isEmpty) {
      final defaults = const Settings();
      await db.insert('settings', {'id': 1, ...defaults.toMap()});
      return defaults;
    }
    return Settings.fromMap(maps.first);
  }

  Future<void> saveSettings(Settings settings) async {
    final db = await database;
    await db.update('settings', {
      'id': 1,
      ...settings.toMap(),
    }, where: 'id = 1');
  }

  // logs
  Future<int> insertLog(Log log) async {
    final db = await database;
    return await db.insert('logs', log.toMap());
  }

  Future<List<Log>> getAllLogs() async {
    final db = await database;
    final maps = await db.query('logs', orderBy: 'date DESC, started_at ASC');
    return maps.map((map) => Log.fromMap(map)).toList();
  }

  Future<int> updateLog(Log log) async {
    final db = await database;
    return await db.update(
      'logs',
      log.toMap(),
      where: 'id = ?',
      whereArgs: [log.id],
    );
  }

  Future<int> deleteLog(int id) async {
    final db = await database;
    return await db.delete('logs', where: 'id = ?', whereArgs: [id]);
  }

  // categories
  Future<int> insertCategory(Category cat) async {
    final now = DateTime.now().toIso8601String();
    final db = await database;
    return db.insert('categories', {
      ...cat.toMap(),
      'created_at': now,
      'updated_at': now,
    });
  }

  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final maps = await db.query('categories', orderBy: 'sort_order ASC');
    return maps.map((m) => Category.fromMap(m)).toList();
  }

  Future<int> updateCategory(Category cat) async {
    final db = await database;
    return db.update(
      'categories',
      {...cat.toMap(), 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [cat.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    await db.delete('tags', where: 'category_id = ?', whereArgs: [id]);
    await db.delete(
      'log_tags',
      where: 'tag_id IN (SELECT id FROM tags WHERE category_id = ?)',
      whereArgs: [id],
    );
    await db.delete(
      'task_tags',
      where: 'tag_id IN (SELECT id FROM tags WHERE category_id = ?)',
      whereArgs: [id],
    );
    return db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  // Tags
  Future<int> insertTag(Tag tag) async {
    final now = DateTime.now().toIso8601String();
    final db = await database;
    return db.insert('tags', {
      ...tag.toMap(),
      'created_at': now,
      'updated_at': now,
    });
  }

  Future<List<Tag>> getTagsByCategory(int categoryId) async {
    final db = await database;
    final maps = await db.query(
      'tags',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'sort_order ASC',
    );
    return maps.map((m) => Tag.fromMap(m)).toList();
  }

  Future<int> updateTag(Tag tag) async {
    final db = await database;
    return db.update(
      'tags',
      {...tag.toMap(), 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [tag.id],
    );
  }

  Future<int> deleteTag(int id) async {
    final db = await database;
    await db.delete('log_tags', where: 'tag_id = ?', whereArgs: [id]);
    await db.delete('task_tags', where: 'tag_id = ?', whereArgs: [id]);
    return db.delete('tags', where: 'id = ?', whereArgs: [id]);
  }

  // Junction helpers
  Future<List<int>> getLogTagIds(int logId) async {
    final db = await database;
    final rows = await db.query(
      'log_tags',
      where: 'log_id = ?',
      whereArgs: [logId],
    );
    return rows.map((r) => r['tag_id'] as int).toList();
  }

  Future<void> setLogTags(int logId, List<int> tagIds) async {
    final db = await database;
    await db.delete('log_tags', where: 'log_id = ?', whereArgs: [logId]);
    for (final id in tagIds) {
      await db.insert('log_tags', {'log_id': logId, 'tag_id': id});
    }
  }

  Future<List<int>> getTaskTagIds(int taskId) async {
    final db = await database;
    final rows = await db.query(
      'task_tags',
      where: 'task_id = ?',
      whereArgs: [taskId],
    );
    return rows.map((r) => r['tag_id'] as int).toList();
  }

  Future<void> setTaskTags(int taskId, List<int> tagIds) async {
    final db = await database;
    await db.delete('task_tags', where: 'task_id = ?', whereArgs: [taskId]);
    for (final id in tagIds) {
      await db.insert('task_tags', {'task_id': taskId, 'tag_id': id});
    }
  }

  Future<List<Map<String, dynamic>>> rawQuery(String sql) async {
    final db = await database;
    return db.rawQuery(sql);
  }
}
