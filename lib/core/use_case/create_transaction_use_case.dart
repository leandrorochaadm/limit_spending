import '../../features/account/domain/usecases/increment_account_value_usecase.dart';
import '../../features/expense/domain/entities/expense_entity.dart';
import '../../features/expense/domain/usecases/usecases.dart';
import '../exceptions/failure.dart';
import '../services/logger_services.dart';

class CreateTransactionUseCase {
  final IncrementAccountValueUseCase incrementAccountValueUseCase;
  final CreateExpenseUseCase createExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;

  CreateTransactionUseCase({
    required this.incrementAccountValueUseCase,
    required this.createExpenseUseCase,
    required this.deleteExpenseUseCase,
  });

  Future<Failure?> call(ExpenseEntity expense) async {
    try {
      // 1. Cria a despesa
      final failureExpense = await createExpenseUseCase(expense);
      if (failureExpense != null) {
        return Failure(
          'Erro ao criar despesa: ${failureExpense.message}',
        );
      }

      //2. se for dinheiro diminui o saldo na conta, se for cartão aumenta o valor devido
      if (expense.accountId != null) {
        final failureAccount = await incrementAccountValueUseCase(
          expense.accountId!,
          expense.isMoney ? -expense.value : expense.value,
        );
        if (failureAccount != null) {
          await _rollbackExpense(expense.id);
          return Failure(
            'Erro ao atualizar saldo da conta: ${failureAccount.message}',
          );
        }
      }

      return null; // Sucesso
    } catch (e, s) {
      // Log detalhado do erro
      LoggerService.error('Erro ao criar transação', e, s);
      return Failure('Erro inesperado ao criar transação.');
    }
  }

  Future<void> _rollbackExpense(String expenseId) async {
    try {
      await deleteExpenseUseCase(expenseId);
    } catch (e, s) {
      LoggerService.error('Erro ao reverter despesa: $expenseId', e, s);
      rethrow;
    }
  }
}
