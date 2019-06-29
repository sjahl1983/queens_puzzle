import 'package:eight_queens_puzzle/src/entities/solution.dart';

abstract class SolutionRepository {
  Future<List<Solution>> fetch();
}
