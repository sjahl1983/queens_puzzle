import 'dart:convert';

class Board {
  int id;
  List<List<int>> data;
  int solutionId;

  Board._({this.id, this.data, this.solutionId});

  Board(int size) {
    data = _makeBoard(size);
  }

  int get size => data.length;

  /// Returns a String representation of the current position
  /// complete with ascii art
  String get ascii {
    String line = '';
    String end = '';
    String s = '';
    for (var i = 0; i < data.length; i++) {
      String extraSpace = i < 10 ? '  ' : '';
      line += ' —';
      if (i == 1) {
        s += '';
      }
      s += '$extraSpace $i |';
      end += '  $i ';

      for (var j = 0; j < data.length; j++) {
        /* empty piece */
        if (data[i][j] == 0) {
          s += '  .  ';
        } else {
          s += ' Q ';
        }

        if ((j + 1) % data.length == 0) {
          s += '|\n';
        }
      }
    }
    String extraSpace = data.length > 10 ? '   ' : '';
    s = '$extraSpace   +$line  +\n' + s;
    s += '$extraSpace   +$line  +\n';
    s += '     $end\n';

    return s;
  }

  static _jsonToData(String json) {
    List data = jsonDecode(json);
    List<List<int>> _values =
        new List.generate(data.length, (_) => new List(data.length));
    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < data.length; j++) {
        _values[i][j] = data[i][j];
      }
    }

    return _values;
  }

  List<List<int>> _makeBoard(int n) {
    List<List<int>> board = new List.generate(n, (_) => new List(n));
    for (int i = 0; i < n; i++)
      for (int j = 0; j < n; j++) board[i][j] = 0; //set all elements to 0

    return board;
  }

  Board clone() {
    Board clone = Board._();
    clone.data = cloneMatrix(data);
    return clone;
  }

  List<List<int>> cloneMatrix(List<List<int>> data) {
    List<List<int>> _values = List(data.length);
    for (int i = 0; i < data.length; i++) {
      _values[i] = []..addAll(data[i]);
    }

    return _values;
  }

  Map<String, dynamic> toMap() =>
      {'id': id, 'solution_id': solutionId, 'data': jsonEncode(data)};

  factory Board.fromMap(Map<String, dynamic> json) => new Board._(
      id: json['id'],
      solutionId: json['solution_id'],
      data: _jsonToData(json['data']));

  void _rotateMatrix() {
    // Consider all squares one by one
    for (int x = 0; x < size / 2; x++) {
      // Consider elements in group of 4 in
      // current square
      for (int y = x; y < size - x - 1; y++) {
        // store current cell in temp variable
        int temp = data[x][y];

        // move values from right to top
        data[x][y] = data[y][size - 1 - x];

        // move values from bottom to right
        data[y][size - 1 - x] = data[size - 1 - x][size - 1 - y];

        // move values from left to bottom
        data[size - 1 - x][size - 1 - y] = data[size - 1 - y][x];

        // assign temp to left
        data[size - 1 - y][x] = temp;
      }
    }
  }

  void _reverse() {
    List<List<int>> array = new List.generate(size, (_) => new List(size));
    ;
    for (int row = size - 1; row >= 0; row--) {
      for (int column = size - 1; column >= 0; column--) {
        array[size - 1 - row][size - 1 - column] = data[row][column];
      }
    }
    data = array;
  }

  void _mirror() {
    List<List<int>> mirrorImage =
        new List.generate(size, (_) => new List(size));
    for (int row = 0; row < size; row++) {
      for (int column = size - 1; column >= 0; column--) {
        mirrorImage[row][size - 1 - column] = data[row][column];
      }
    }
    data = mirrorImage;
  }

  bool checkUnique(List<Board> boards) {
    Board board = this.clone();
    for (int k = 0; k < 4; k++) {
      board._rotateMatrix();
      for (int i = 0; i < boards.length; i++) {
        if (boards[i].equals(board)) {
          return false;
        } else {
          Board b = board.clone();
          b._mirror();
          if (boards[i].equals(b)) {
            return false;
          }
        }
      }
    }
    return true;
  }

  bool equals(Board board) {
    if (size != board.size) {
      return false;
    }
    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (data[i][j] != board.data[i][j]) {
          return false;
        }
      }
    }
    return true;
  }
}
