import 'package:eight_queens_puzzle/src/entities/board.dart';

abstract class BoardRepository {
  Future<List<Board>> fetchBySolutionId(int id);
}
