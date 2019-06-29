import 'dart:io';

import 'package:eight_queens_puzzle/src/entities/board.dart';
import 'package:eight_queens_puzzle/src/entities/solution.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Board ('
          ' id INTEGER PRIMARY KEY,'
          ' data TEXT,'
          ' solution_id INTEGER'
          ')');

      await db.execute('CREATE TABLE Solution ('
          ' id INTEGER PRIMARY KEY,'
          ' size INTEGER,'
          ' createdDate TEXT'
          ')');
    });
  }

  Future<int> newSolution(Solution newSolution) async {
    final db = await database;
    final res = await db.insert('Solution', newSolution.toMap());

    return res;
  }

  Future<List<Solution>> getAllSolutions() async {
    final db = await database;
    final res = await db.query('Solution');

    List<Solution> list =
        res.isNotEmpty ? res.map((c) => Solution.fromMap(c)).toList() : [];
    return list;
  }

  newBoard(Board newBoard) async {
    final db = await database;
    final res = await db.insert('Board', newBoard.toMap());
    return res;
  }

  Future<List<Board>> getAllBoardsBySolutionId(int solutionId) async {
    final db = await database;
    final res = await db
        .query('Board', where: 'solution_id = ?', whereArgs: [solutionId]);
    List<Board> list =
        res.isNotEmpty ? res.map((c) => Board.fromMap(c)).toList() : [];

    return list;
  }
}
