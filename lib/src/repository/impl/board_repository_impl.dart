import 'dart:async';

import 'package:eight_queens_puzzle/src/entities/board.dart';
import 'package:eight_queens_puzzle/src/providers/db_provider.dart';
import 'package:eight_queens_puzzle/src/repository/board_repository.dart';

class BoardRepositoryImpl implements BoardRepository {
  @override
  Future<List<Board>> fetchBySolutionId(int id) async {
    return await DBProvider.db.getAllBoardsBySolutionId(id);
  }
}
