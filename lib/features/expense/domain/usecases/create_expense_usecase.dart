import '../../../../core/factories/factories.dart';
import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class CreateExpenseUseCase {
  final ExpenseRepository _expenseRepository;
  CreateExpenseUseCase(this._expenseRepository);
  Future<void> call(ExpenseEntity expenseEntity) async {
    await _expenseRepository.createExpense(expenseEntity.toModel());

    await makeIncrementValuePaymentMethodUseCase(
      paymentMethodId: expenseEntity.paymentMethodId,
      value: expenseEntity.value,
    );
  }
}
