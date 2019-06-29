import 'package:eight_queens_puzzle/src/repository/board_repository.dart';
import 'package:eight_queens_puzzle/src/repository/impl/board_repository_impl.dart';
import 'package:eight_queens_puzzle/src/repository/impl/solution_repository_impl.dart';
import 'package:eight_queens_puzzle/src/repository/solution_repository.dart';

enum Environment { MOCK, PROD }

class Injector {
  static final Injector _singleton = new Injector._internal();

  static Environment _env;

  static void configure(Environment flavor) {
    _env = flavor;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  SolutionRepository get solutionRepository {
    switch (_env) {
      default:
        return new SolutionRepositoryImpl();
    }
  }

  BoardRepository get boardRepository {
    switch (_env) {
      default:
        return new BoardRepositoryImpl();
    }
  }
}
