import '../../features/debt/debit.dart';
import '../../features/expense/domain/entities/expense_entity.dart';
import '../../features/expense/domain/usecases/usecases.dart';
import '../../features/payment_method/domain/use_cases/use_cases.dart';
import '../exceptions/failure.dart';
import '../services/logger_services.dart';

class CreateTransactionUseCase {
  final IncrementValuePaymentMethodUseCase incrementValuePaymentMethodUseCase;
  final AddDebtValueUseCase addDebtValueUseCase;
  final CreateExpenseUseCase createExpenseUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;

  CreateTransactionUseCase({
    required this.incrementValuePaymentMethodUseCase,
    required this.addDebtValueUseCase,
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

      // 2. Diminui o saldo do meio de pagamento
      final failurePaymentMethod = await incrementValuePaymentMethodUseCase(
        paymentMethodId: expense.paymentMethodId,
        value: expense.value,
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
