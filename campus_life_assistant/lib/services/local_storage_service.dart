import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/class_schedule.dart';

class LocalStorageService {
  static const String _tableName = 'class_schedules';
  static Database? _database;

  static Future<void> initialize() async {
    final path = join(await getDatabasesPath(), 'class_schedules.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            startTime TEXT,
            endTime TEXT
          )
        ''');
      },
    );
  }

  Future<void> addClassSchedule(ClassSchedule schedule) async {
    await _database?.insert(_tableName, schedule.toMap());
  }

  Future<void> updateClassSchedule(ClassSchedule schedule) async {
    await _database?.update(
      _tableName,
      schedule.toMap(),
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }

  Future<void> deleteClassSchedule(String id) async {
    await _database?.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<ClassSchedule>> getClassSchedules() async {
    final List<Map<String, dynamic>>? maps =
        await _database?.query(_tableName);
    return maps?.map((map) => ClassSchedule.fromMap(map)).toList() ?? [];
  }
}
