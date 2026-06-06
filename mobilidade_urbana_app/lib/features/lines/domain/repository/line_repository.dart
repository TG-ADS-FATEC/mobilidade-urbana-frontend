import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/line_entity.dart';

abstract class LineRepository {
  Future<DataState<({List<LineEntity> items, bool hasNext})>> getLines({int page = 0, int size = 20});
  Future<DataState<List<LineEntity>>> searchLines(String query);
}
