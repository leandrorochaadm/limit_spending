import 'dart:developer';

class LoggerService {
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    log(message, stackTrace: stackTrace, error: error);
  }
}
