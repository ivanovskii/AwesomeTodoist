import 'dart:async';
import 'package:path/path.dart' show join;
import 'package:awesome_todoist/TodoModel.dart';
import 'package:sqflite/sqflite.dart';

// Created using this tutorial:
// https://pub.dev/packages/sqflite

class SQLHelper {
  Database? database;

  void onCreate(Database db, int version) async {
    return (await db.execute(
        'CREATE TABLE Todo ('
            'id INTEGER PRIMARY KEY,'
            'description TEXT NOT NULL,'
            'notifyAt TEXT,'
            'done INTEGER)')
    );
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), "todo_db.db");
    return await openDatabase(path, version: 1, onCreate: onCreate);
  }

  Future<Database?> get db async {
    return database ?? await initDatabase();
  }

  Future<int?> insert(Todo todo) async {
    var database = await db;
    return await database!.insert('Todo', todo.toMap());
  }

  Future<Todo> getTodo(int id) async {
    var database = await db;
    var maps = await database!.rawQuery('SELECT * FROM Todo WHERE id = $id');
    return Todo.fromMap(maps.first);
  }

  Future<int> update(Todo todo) async {
    var database = await db;
    return await database!.update("Todo", todo.toMap(),
        where: 'id = ?',
        whereArgs: [todo.id]);
  }

  Future<List> all() async {
    var database = await db;
    return (await database!.rawQuery('SELECT * FROM Todo')).toList();
  }

  Future<int> delete(int id) async {
    var database = await db;
    return await database!.delete('Todo', where: 'id = ?', whereArgs: [id]);
  }

  Future clear() async {
    var database = await db;
    return await database!.rawQuery('DELETE FROM Todo');
  }

  Future close() async => database!.close();
}