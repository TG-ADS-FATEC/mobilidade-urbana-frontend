import 'package:mobilidade_urbana_app/core/error/failures.dart';

sealed class DataState<T> {
  const DataState();
}

final class DataSuccess<T> extends DataState<T> {
  final T data;
  const DataSuccess(this.data);
}

final class DataFailed<T> extends DataState<T> {
  final AppFailure failure;
  const DataFailed(this.failure);
}