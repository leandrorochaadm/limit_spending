import '../../features/debt/debit.dart';
import '../../features/expense/domain/domain.dart';
import '../../features/payment_method/domain/domain.dart';
import '../exceptions/exceptions.dart';
import '../services/logger_services.dart';

class DeleteTransactionUseCase {
  final IncrementValuePaymentMethodUseCase incrementValuePaymentMethodUseCase;
  final AddDebtValueUseCase addDebtValueUseCase;
  final CreateExpenseUseCase createExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;

  DeleteTransactionUseCase({
    required this.incrementValuePaymentMethodUseCase,
    required this.addDebtValueUseCase,
    required this.createExpenseUseCase,
    required this.deleteExpenseUseCase,
  });

  Future<Failure?> call(ExpenseEntity expense) async {
    try {
// 1. Cria a despesa
      final failureExpense = await deleteExpenseUseCase(expense.id);
      if (failureExpense != null) {
        return Failure(
          'Erro ao criar despesa: ${failureExpense.message}',
        );
      }

//2. se for dinheiro aumenta o saldo no meio de pagamento, se for cartão diminui o valor da divida
      final failurePaymentMethod = await incrementValuePaymentMethodUseCase(
        paymentMethodId: expense.paymentMethodId,
        value: expense.isMoney ? expense.value : -expense.value,
      );
      if (failurePaymentMethod != null) {
        await _rollbackExpense(expense.id);
        return Failure(
          'Erro ao atualizar saldo do meio de pagamento: ${failurePaymentMethod.message}',
        );
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
