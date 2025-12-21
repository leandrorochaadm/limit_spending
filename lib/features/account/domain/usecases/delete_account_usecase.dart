import '../../../../core/exceptions/exceptions.dart';
import '../../../expense/domain/repositories/expense_repository.dart';
import '../entities/account_entity.dart';
import '../repositories/account_repository.dart';

class DeleteAccountUseCase {
  final AccountRepository accountRepository;
  final ExpenseRepository expenseRepository;

  DeleteAccountUseCase({
    required this.accountRepository,
    required this.expenseRepository,
  });

  Future<Failure?> call(AccountEntity account) async {
    try {
      // 1. Deletar todas as expenses associadas (cascade)
      await expenseRepository.deleteExpensesByAccount(account.id);

      // 2. Deletar a conta
      await accountRepository.deleteAccount(account);

      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao deletar conta: $e');
    }
  }
}
