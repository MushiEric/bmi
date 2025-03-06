import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BMIDBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'bmi_history.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE history(id INTEGER PRIMARY KEY AUTOINCREMENT, bmi REAL, status TEXT, date TEXT)",
        );
      },
    );
  }

  Future<void> insertBMI(double bmi, String status) async {
    final db = await database;
    await db.insert(
      'history',
      {'bmi': bmi, 'status': status, 'date': DateTime.now().toIso8601String()},
    );
  }

  Future<List<Map<String, dynamic>>> getBMIHistory() async {
    final db = await database;
    return await db.query('history', orderBy: "date DESC");
  }

  // ✅ Fix: Add the missing `clearHistory()` function
  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('history'); // This clears all records in the history table
  }
}
