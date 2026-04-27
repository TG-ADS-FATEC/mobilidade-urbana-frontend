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

final class CacheFailure extends AppFailure {
  const CacheFailure([super.message = 'Erro ao acessar dados locais']);
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure([super.message = 'Dados inválidos']);
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure([super.message = 'Ocorreu um erro desconhecido']);
}