import '../../../../core/exceptions/exceptions.dart';
import '../entities/account_entity.dart';
import '../entities/account_type.dart';
import '../repositories/account_repository.dart';

class GetAccountsByTypeUseCase {
  final AccountRepository repository;

  GetAccountsByTypeUseCase(this.repository);

  Future<(Failure?, List<AccountEntity>?)> call(
    AccountType type, [
    bool isValueGreaterThanZero = true,
  ]) async {
    try {
      final accounts = await repository.getAccountsByType(
        type,
        isValueGreaterThanZero,
      );
      return (null, accounts);
    } on AppException catch (e) {
      return (Failure(e.message), null);
    } catch (e) {
      return (Failure('Erro ao buscar contas por tipo: $e'), null);
    }
  }
}
