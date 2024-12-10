import '../../features/debt/debit.dart';
import '../../features/expense/domain/domain.dart';
import '../../features/payment_method/domain/domain.dart';
import '../exceptions/exceptions.dart';

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
    final failureExpense = await createExpenseUseCase(expense);

    if (failureExpense != null) {
      return Failure('Erro ao criar despesa: ${failureExpense.message}');
    }

    // diminiui o saldo do meio de pagamento
    final failurePaymentMethod = await incrementValuePaymentMethodUseCase(
      paymentMethodId: expense.paymentMethodId,
      value: -expense.value,
    );

    if (failurePaymentMethod != null) {
      deleteExpenseUseCase(expense.id);
      return Failure('Erro ao criar despesa: ${failurePaymentMethod.message}');
    }
    return null;
  }
}
