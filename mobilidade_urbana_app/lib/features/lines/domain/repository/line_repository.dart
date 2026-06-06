import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/line_entity.dart';

abstract class LineRepository {
  Future<DataState<List<LineEntity>>> getLines();
  Future<DataState<List<LineEntity>>> searchLines(String query);
}
