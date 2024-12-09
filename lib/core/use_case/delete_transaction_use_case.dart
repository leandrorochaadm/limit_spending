import '../../features/debt/debit.dart';
import '../../features/expense/domain/domain.dart';
import '../../features/payment_method/domain/domain.dart';
import '../exceptions/exceptions.dart';

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
    final failureExpense = await deleteExpenseUseCase(expense.id);

    if (failureExpense != null) {
      return Failure('Erro ao exluir despesa: ${failureExpense.message}');
    }

    final failurePaymentMethod = await incrementValuePaymentMethodUseCase(
      paymentMethodId: expense.paymentMethodId,
      value: -expense.value,
    );

    if (failurePaymentMethod != null) {
      // desfaz a exclusão
      await createExpenseUseCase(expense);
      return Failure('Erro ao criar despesa: ${failurePaymentMethod.message}');
    }
    return null;
  }
}
