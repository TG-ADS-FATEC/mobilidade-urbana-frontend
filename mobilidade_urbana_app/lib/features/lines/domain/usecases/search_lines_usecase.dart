import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/line_entity.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/repository/line_repository.dart';

class SearchLinesUsecase {
  final LineRepository repository;

  const SearchLinesUsecase(this.repository);

  Future<DataState<List<LineEntity>>> call(String query) async {
    return await repository.searchLines(query);
  }
}
