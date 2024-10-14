import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  DBHelper._internal();

  factory DBHelper() => _instance;


  static const String _dbName = 'notes.db';
  static const String _tableName = 'tasks';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT ,
        description TEXT ,
        dueDate TEXT ,
        category TEXT 
      )
    ''');
  }


  Future<int> createTask(Map<String, dynamic> task) async {
    try {
      final db = await database;
      return await db.insert(_tableName, task);
    } catch (e) {

      print('Error creating task: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getTask() async {
    try {
      final db = await database;
      return await db.query(_tableName);
    } catch (e) {

      print('Error fetching tasks: $e');
      return [];
    }
  }

  Future<int> updateTask(int id, Map<String, dynamic> task) async {
    try {
      final db = await database;
      return await db.update(_tableName, task, where: 'id = ?', whereArgs: [id]);
    } catch (e) {

      print('Error updating task: $e');
      return 0;
    }
  }

  Future<int> deleteTask(int id) async {
    try {
      final db = await database;
      return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting task: $e');
      return 0;
    }
  }
}
