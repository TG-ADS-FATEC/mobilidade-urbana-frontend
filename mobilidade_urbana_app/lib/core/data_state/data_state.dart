sealed class DataState<T> {
  const DataState();
}

final class DataSuccess<T> extends DataState<T> {
  final T data;
  const DataSuccess(this.data);
}

final class DataFailed<T> extends DataState<T> {
  final Exception error;
  final String? message;
  const DataFailed(this.error, {this.message});
}