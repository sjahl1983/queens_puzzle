import 'package:eight_queens_puzzle/src/di/dependency_injection.dart';
import 'package:eight_queens_puzzle/src/entities/board.dart';
import 'package:eight_queens_puzzle/src/repository/board_repository.dart';
import 'package:eight_queens_puzzle/src/view/list_item_view.dart';

class BoardPresenter {

    ListItemView<Board> _view;
    BoardRepository _boardRepository;

    BoardPresenter(this._view){
      this._boardRepository = new Injector().boardRepository;
    }

    void loadBoards(int id){
      this._boardRepository
          .fetchBySolutionId(id)
          .then((result)=> this._view.onLoadComplete(result))
          .catchError((onError) => this._view.onLoadError());
    }

}