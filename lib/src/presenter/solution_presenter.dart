import 'package:eight_queens_puzzle/src/di/dependency_injection.dart';
import 'package:eight_queens_puzzle/src/entities/solution.dart';
import 'package:eight_queens_puzzle/src/repository/solution_repository.dart';
import 'package:eight_queens_puzzle/src/view/list_item_view.dart';

class SolutionPresenter {
  ListItemView<Solution> _view;
  SolutionRepository _solutionRepository;

  SolutionPresenter(this._view) {
    this._solutionRepository = new Injector().solutionRepository;
  }

  void loadSolutions() {
    this
        ._solutionRepository
        .fetch()
        .then((result) => this._view.onLoadComplete(result))
        .catchError((onError) => this._view.onLoadError());
  }
}
