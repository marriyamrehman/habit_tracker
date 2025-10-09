import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  // Database name and version
  static const String _dbName = 'habit_tracker.db';
  static const int _dbVersion = 1;

  // Table name and columns
  static const String tableHabits = 'habits';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnCompleted = 'completed';

  // Singleton pattern
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  // Create tables
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableHabits (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnCompleted INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // Insert a new habit
  Future<int> insertHabit(Map<String, dynamic> habit) async {
    Database db = await instance.database;
    return await db.insert(tableHabits, habit);
  }

  // Get all habits
  Future<List<Map<String, dynamic>>> getHabits() async {
    Database db = await instance.database;
    return await db.query(tableHabits);
  }

  // Update habit (toggle completion)
  Future<int> updateHabit(Map<String, dynamic> habit) async {
    Database db = await instance.database;
    int id = habit[columnId];
    return await db.update(
      tableHabits,
      habit,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Delete habit
  Future<int> deleteHabit(int id) async {
    Database db = await instance.database;
    return await db.delete(
      tableHabits,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
