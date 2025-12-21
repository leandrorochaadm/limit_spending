import '../../../../core/exceptions/exceptions.dart';
import '../repositories/account_repository.dart';

class IncrementAccountValueUseCase {
  final AccountRepository repository;

  IncrementAccountValueUseCase(this.repository);

  Future<Failure?> call(String accountId, double value) async {
    try {
      await repository.incrementAccountValue(accountId, value);
      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao incrementar valor da conta: $e');
    }
  }
}
