import 'package:firebase_core/firebase_core.dart';

import 'exceptions_custom.dart';

class AppExceptionUtils {
  AppExceptionUtils._();

  /// Função para mapear erros Firebase para AppException
  static AppException handleFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return PermissionDeniedException();
      case 'network-error':
        return NetworkErrorException();
      case 'not-found':
        return ResourceNotFoundException();
      default:
        return UnknownErrorException();
    }
  }
}
