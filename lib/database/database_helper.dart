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
      version: 4,
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
            await db.update('logs', {'date': newDate},
                where: 'id = ?', whereArgs: [map['id']]);
          }
        }
      }
    }
  }

  // CRUD methods
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
}
