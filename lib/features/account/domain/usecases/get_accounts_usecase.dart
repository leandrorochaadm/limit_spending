import '../../../../core/exceptions/exceptions.dart';
import '../entities/account_entity.dart';
import '../repositories/account_repository.dart';

class GetAccountsUseCase {
  final AccountRepository repository;

  GetAccountsUseCase(this.repository);

  Future<(Failure?, List<AccountEntity>?)> call([
    bool isValueGreaterThanZero = true,
  ]) async {
    try {
      final accounts = await repository.getAccounts(isValueGreaterThanZero);
      return (null, accounts);
    } on AppException catch (e) {
      return (Failure(e.message), null);
    } catch (e) {
      return (Failure('Erro ao buscar contas: $e'), null);
    }
  }
}
