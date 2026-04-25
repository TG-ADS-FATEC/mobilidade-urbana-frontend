sealed class AppFailure {
  final String message;
  const AppFailure(this.message);
}

final class ServerFailure extends AppFailure {
  const ServerFailure([super.message = 'Erro no servidor']);
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'Sem conexão']);
}