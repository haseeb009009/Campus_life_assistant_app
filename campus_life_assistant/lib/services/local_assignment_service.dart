import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/assignment.dart';

class LocalAssignmentService {
  static const String _tableName = 'assignments';
  static Database? _database;

  static Future<void> initialize() async {
    final path = join(await getDatabasesPath(), 'assignments.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            dueDate TEXT
          )
        ''');
      },
    );
  }

  Future<void> addAssignment(Assignment assignment) async {
    await _database?.insert(_tableName, assignment.toMap());
  }

  Future<void> updateAssignment(Assignment assignment) async {
    await _database?.update(
      _tableName,
      assignment.toMap(),
      where: 'id = ?',
      whereArgs: [assignment.id],
    );
  }

  Future<void> deleteAssignment(String id) async {
    await _database?.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Assignment>> getAssignments() async {
    final List<Map<String, dynamic>>? maps = await _database?.query(_tableName);
    return maps?.map((map) => Assignment.fromMap(map)).toList() ?? [];
  }
}
