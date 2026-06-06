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
  Future<DataState<List<LineEntity>>> getLines() async {
    try {
      final lines = await _remote.getLines();
      return DataSuccess(lines);
    } on DioException catch (e) {
      return DataFailed(_failure(e, 'Erro ao carregar linhas'));
    }
  }

  @override
  Future<DataState<List<LineEntity>>> searchLines(String query) async {
    try {
      final lines = await _remote.searchLines(query);
      return DataSuccess(lines);
    } on DioException catch (e) {
      return DataFailed(_failure(e, 'Erro ao buscar linhas'));
    }
  }

  AppFailure _failure(DioException e, String fallback) =>
      e.type == DioExceptionType.connectionError ||
              e.type == DioExceptionType.connectionTimeout
          ? NetworkFailure()
          : ServerFailure(e.message ?? fallback);
}
