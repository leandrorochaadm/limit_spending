import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository _expenseRepository;
  DeleteExpenseUseCase(this._expenseRepository);
  Future<void> call(ExpenseEntity expenseEntity) async =>
      await _expenseRepository.deleteExpense(expenseEntity.toModel());
}