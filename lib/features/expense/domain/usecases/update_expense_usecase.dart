import '../domain.dart';

class UpdateExpenseUseCase {
  final ExpenseRepository _expenseRepository;
  UpdateExpenseUseCase(this._expenseRepository);
  Future<void> call(ExpenseEntity expenseEntity) async =>
      await _expenseRepository.updateExpense(expenseEntity.toModel());
}
