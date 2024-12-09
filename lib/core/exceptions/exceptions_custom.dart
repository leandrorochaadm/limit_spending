/// Classe base para exceções no aplicativo
abstract class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

/// Exceção para erro de permissão
class PermissionDeniedException extends AppException {
  PermissionDeniedException()
      : super('Você não tem permissão para acessar este recurso.');
}

/// Exceção para erro de conexão de rede
class NetworkErrorException extends AppException {
  NetworkErrorException() : super('Falha na conexão. Verifique sua internet.');
}

/// Exceção para recurso não encontrado
class ResourceNotFoundException extends AppException {
  ResourceNotFoundException() : super('Recurso não encontrado.');
}

/// Exceção para erros desconhecidos
class UnknownErrorException extends AppException {
  UnknownErrorException()
      : super('Ocorreu um erro desconhecido. Tente novamente mais tarde.');
}
