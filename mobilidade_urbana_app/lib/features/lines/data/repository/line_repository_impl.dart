import 'package:dio/dio.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/error/failures.dart';
import 'package:mobilidade_urbana_app/features/lines/data/data_sources/line_remote_datasource.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/entities/line_entity.dart';
import 'package:mobilidade_urbana_app/features/lines/domain/repository/line_repository.dart';

class LineRepositoryImpl implements LineRepository {
  final LineRemoteDatasource _remote;

  LineRepositoryImpl(this._remote);

  @override
  Future<DataState<({List<LineEntity> items, bool hasNext})>> getLines({int page = 0, int size = 20}) async {
    try {
      final result = await _remote.getLines(page: page, size: size);
      return DataSuccess((items: result.items, hasNext: result.hasNext));
    } on DioException catch (e) {
      return DataFailed(_failure(e, 'Erro ao carregar linhas'));
    } catch (e) {
      return DataFailed(ServerFailure(e.toString()));
    }
  }

  @override
  Future<DataState<List<LineEntity>>> searchLines(String query) async {
    try {
      final lines = await _remote.searchLines(query);
      return DataSuccess(lines);
    } on DioException catch (e) {
      return DataFailed(_failure(e, 'Erro ao buscar linhas'));
    } catch (e) {
      return DataFailed(ServerFailure(e.toString()));
    }
  }

  AppFailure _failure(DioException e, String fallback) =>
      e.type == DioExceptionType.connectionError ||
              e.type == DioExceptionType.connectionTimeout
          ? NetworkFailure()
          : ServerFailure(e.message ?? fallback);
}
