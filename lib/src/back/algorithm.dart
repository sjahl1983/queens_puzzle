import 'dart:convert';

import 'package:eight_queens_puzzle/src/entities/board.dart';

class Algorithm {
  List<Board> boards;

  List<Board> generateSolutions(n) {
    boards = new List();
    Board board = Board(n);

    if (solveRepeat(board) == false) {
      print("Solution does not exist");
    }
    return boards;
  }

  static void printSolution(List<Board> boards) {
    for (int i = 0; i < boards.length; i++) {
      print('solution_${boards[i].id}');
      String json = jsonEncode(boards[i]);
      print(json);
    }
  }

  bool isSafe(Board board, int row, int col) {
    for (int i = 0; i < col; i++) {
      if (board.data[row][i] == 1) {
        return false;
      }
    }

    for (int i = row, j = col; i >= 0 && j >= 0; i--, j--) {
      if (board.data[i][j] == 1) {
        return false;
      }
    }

    for (int i = row, j = col; j >= 0 && i < board.size; i++, j--) {
      if (board.data[i][j] == 1) {
        return false;
      }
    }

    return true;
  }

  bool solveRepeat(Board board, {int col = 0}) {
    if (col == board.size) {
      boards.add(board.clone());
      return true;
    }

    bool res = false;
    for (int i = 0; i < board.size; i++) {
      if (isSafe(board, i, col)) {
        board.data[i][col] = 1;
        res = solveRepeat(board, col: col + 1) || res;
        board.data[i][col] = 0;
      }
    }

    return res;
  }
}
