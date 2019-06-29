import 'dart:async';
import 'dart:convert';

import 'package:eight_queens_puzzle/src/entities/solution.dart';
import 'package:eight_queens_puzzle/src/providers/db_provider.dart';
import 'package:eight_queens_puzzle/src/repository/solution_repository.dart';

class SolutionRepositoryImpl implements SolutionRepository {
  @override
  Future<List<Solution>> fetch() async {
    return await DBProvider.db.getAllSolutions();
  }
}
