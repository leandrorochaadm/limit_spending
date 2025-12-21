import '../../../../core/exceptions/exceptions.dart';
import '../entities/account_entity.dart';
import '../repositories/account_repository.dart';

class CreateAccountUseCase {
  final AccountRepository repository;

  CreateAccountUseCase(this.repository);

  Future<Failure?> call(AccountEntity account) async {
    try {
      final accountModel = account.toModel();
      await repository.createAccount(accountModel);
      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao criar conta: $e');
    }
  }
}
