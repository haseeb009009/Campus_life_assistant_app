import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/event.dart';

class LocalEventService {
  static const String _tableName = 'events';
  static Database? _database;

  static Future<void> initialize() async {
    final path = join(await getDatabasesPath(), 'events.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            name TEXT,
            location TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<void> addEvent(Event event) async {
    await _database?.insert(_tableName, event.toMap());
  }

  Future<void> updateEvent(Event event) async {
    await _database?.update(
      _tableName,
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  Future<void> deleteEvent(String id) async {
    await _database?.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Event>> getEvents() async {
    final List<Map<String, dynamic>>? maps = await _database?.query(_tableName);
    return maps?.map((map) => Event.fromMap(map)).toList() ?? [];
  }
}
