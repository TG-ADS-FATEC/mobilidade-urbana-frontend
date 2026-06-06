import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/line_entity.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/repository/line_repository.dart';

class GetLinesUsecase {
  final LineRepository repository;

  const GetLinesUsecase(this.repository);

  Future<DataState<({List<LineEntity> items, bool hasNext})>> call({int page = 0, int size = 20}) async {
    return await repository.getLines(page: page, size: size);
  }
}
