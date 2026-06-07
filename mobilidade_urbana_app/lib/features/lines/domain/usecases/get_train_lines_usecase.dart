import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/line_entity.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/repository/line_repository.dart';

class GetTrainLinesUsecase {
  final LineRepository repository;

  const GetTrainLinesUsecase(this.repository);

  Future<DataState<List<LineEntity>>> call() async {
    return await repository.getTrainLines();
  }
}
