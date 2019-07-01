import 'package:eight_queens_puzzle/src/di/dependency_injection.dart';
import 'package:eight_queens_puzzle/src/entities/board.dart';
import 'package:eight_queens_puzzle/src/entities/solution.dart';
import 'package:eight_queens_puzzle/src/presenter/solution_presenter.dart';
import 'package:eight_queens_puzzle/src/repository/board_repository.dart';
import 'package:eight_queens_puzzle/src/view/list_item_view.dart';
import 'package:flutter/material.dart';

class SolutionPage extends StatefulWidget {
  @override
  _SolutionPageState createState() => new _SolutionPageState();
}

class _SolutionPageState extends State<SolutionPage>
    implements ListItemView<Solution> {
  final List<MaterialColor> _colors = [
    Colors.blue,
    Colors.indigo,
    Colors.red,
    Colors.blueGrey
  ];

  BoardRepository _boardRepository;
  SolutionPresenter _solutionPresenter;
  List<Solution> _solutionList = [];
  bool _isLoading = false;

  _SolutionPageState() {
    _boardRepository = Injector().boardRepository;
    _solutionPresenter = new SolutionPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    this._isLoading = true;
    this._solutionPresenter.loadSolutions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Solutions')),
      body: _isLoading
          ? new Center(
              child: new CircularProgressIndicator(),
            )
          : _solutionsWidget(),
    );
  }

  Widget _solutionsWidget() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Flexible(
              child: new ListView.builder(
                  itemCount: _solutionList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Solution item = _solutionList[index];
                    final MaterialColor color = _colors[index % _colors.length];
                    return _getItem(context, index, item, color);
                  }))
        ],
      ),
    );
  }

  ListTile _getItem(
      BuildContext context, int index, Solution item, MaterialColor color) {
    return new ListTile(
      leading: new CircleAvatar(
        backgroundColor: color,
        child: new Text('${index + 1}'),
      ),
      title: new Text(
        '${item.createdDate.toString()}, Size: ${item.size}',
        style: TextStyle(fontSize: 15),
      ),
      onTap: () => _onTapItem(context, item),
    );
  }

  _onTapItem(BuildContext context, Solution item) async {
    List<Board> boards = await _boardRepository.fetchBySolutionId(item.id);

    Navigator.pop(context, boards);
  }

  @override
  void onLoadComplete(List<Solution> items) {
    setState(() {
      this._solutionList = items;
      this._isLoading = false;
    });
  }

  @override
  void onLoadError() {
    // TODO: implement onLoadError
  }
}
