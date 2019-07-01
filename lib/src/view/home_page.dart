import 'package:eight_queens_puzzle/src/back/algorithm.dart';
import 'package:eight_queens_puzzle/src/components/buttons/text_button.dart';
import 'package:eight_queens_puzzle/src/entities/board.dart';
import 'package:eight_queens_puzzle/src/entities/solution.dart';
import 'package:eight_queens_puzzle/src/providers/db_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autoValidate = true;

  final _boardSizeController = TextEditingController();

  List<Board> _boards = List();

  final List<MaterialColor> _colors = [
    Colors.blue,
    Colors.indigo,
    Colors.red,
    Colors.blueGrey
  ];

  @override
  void initState() {
    super.initState();
  }

  List<Board> solve({int size = 8}) {
    Algorithm algorithm = Algorithm();

    return algorithm.generateSolutions(size);
  }

  void _saveBoards() async {
    if (_boards.length > 0 && _boards[0].solutionId == null) {
      Solution solution = Solution(size: _boards[0].size);
      int _solutionId = await DBProvider.db.newSolution(solution);

      for (int i = 0; i < _boards.length; i++) {
        _boards[i].solutionId = _solutionId;
        DBProvider.db.newBoard(_boards[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Queen Puzzle'),
        elevation: defaultTargetPlatform == TargetPlatform.iOS ? 0.0 : 5.0,
      ),
      body: _boardsWidget(),
      persistentFooterButtons: <Widget>[
        TextButton(
          buttonName: 'Unique Solutions',
          buttonTextStyle: TextStyle(color: Colors.blue),
          onPressed: _showUniqueSolutions,
        ),
        TextButton(
          buttonName: 'Solutions',
          buttonTextStyle: TextStyle(color: Colors.blue),
          onPressed: () => _allSolutions(context),
        ),
        TextButton(
          key: Key('board_size_button'),
          buttonName: 'Size',
          onPressed: () => _showBoardSize(context),
          buttonTextStyle: TextStyle(color: Colors.blue),
        ),
        TextButton(
          buttonName: 'Save',
          onPressed: _saveBoards,
          buttonTextStyle: TextStyle(color: Colors.blue),
        )
      ], // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _boardsWidget() {
    return new Container(
      child: new Column(
        children: <Widget>[
          Text('Solutions: ${_boards.length}',
              style: TextStyle(
                  fontSize: 20,
                  color: _boards.length == 0 ? Colors.red : Colors.green)),
          new Flexible(
              child: new ListView.builder(
                  itemCount: _boards.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Board item = _boards[index];
                    final MaterialColor color = _colors[index % _colors.length];
                    return _getItem(index, item, color);
                  }))
        ],
      ),
    );
  }

  ListTile _getItem(int index, Board item, MaterialColor color) {
    return new ListTile(
      key: Key('solutions'),
      leading: new CircleAvatar(
        backgroundColor: color,
        child: new Text('${index + 1}'),
      ),
      title: new Text(
        item.ascii,
        style: TextStyle(fontFamily: 'Courier', fontSize: 15),
      ),
    );
  }

  void _showBoardSize(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Board Size'),
            content: new Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: TextFormField(
                key: Key('board_size_field'),
                controller: _boardSizeController,
                keyboardType: TextInputType.number,
                validator: _validateSize,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                key: Key('board_size_solve_button'),
                child: Text('Solve'),
                onPressed: () => _validateInputs(context),
              )
            ],
          );
        });
  }

  String _validateSize(String arg) {
    Pattern pattern = r'^[0-9]{1,2}$';
    RegExp regExp = new RegExp(pattern);

    if (regExp.hasMatch(arg)) {
      int size = int.parse(arg);
      if (size > 15) {
        return 'max value is 15';
      } else if (size < 4) {
        return 'min value is 4';
      } else {
        return null;
      }
    } else {
      return 'Invalid char';
    }
  }

  void _validateInputs(context) {
    if (_formKey.currentState.validate()) {
      _changeSize(context);
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _changeSize(BuildContext context) {
    List<Board> boards = solve(size: int.parse(_boardSizeController.text));

    Navigator.pop(context);
  }

  void _showUniqueSolutions() {
    List<Board> boards = new List();
    while (_boards.length > 0) {
      Board b = _boards.removeAt(0);
      if (b.checkUnique(boards)) {
        boards.add(b);
      }
    }

    setState(() {
      _boards = boards;
    });
  }

  void _allSolutions(BuildContext context) async {
    var reponse = await Navigator.pushNamed(context, 'solutions');

    if (reponse != null) {
      setState(() {
        _boards = reponse;
      });
    }
  }

  @override
  void dispose() {
    _boardSizeController.dispose();
    super.dispose();
  }
}
