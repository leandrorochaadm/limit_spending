import '../../../debt/domain/usecases/add_debt_value_usecase.dart';
import '../../../payment_method/payment_method.dart';
import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository expenseRepository;
  final IncrementValuePaymentMethodUseCase incrementValuePaymentMethodUseCase;
  final AddDebtValueUseCase addDebtValueUseCase;

  DeleteExpenseUseCase({
    required this.expenseRepository,
    required this.incrementValuePaymentMethodUseCase,
    required this.addDebtValueUseCase,
  });

  Future<void> call(ExpenseEntity expenseEntity) async {
    await expenseRepository.deleteExpense(expenseEntity.toModel());

    await incrementValuePaymentMethodUseCase(
      paymentMethodId: expenseEntity.paymentMethodId,
      value: -expenseEntity.value,
    );

    await addDebtValueUseCase(
      debtId: expenseEntity.paymentMethodId,
      debtValue: -expenseEntity.value,
    );
  }
}
