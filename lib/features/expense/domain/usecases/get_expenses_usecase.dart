import '../../../expense/domain/domain.dart';

class GetExpensesUseCase {
  final ExpenseRepository _expenseRepository;

  GetExpensesUseCase(this._expenseRepository);
  Stream<List<ExpenseEntity>> call(String categoryId) {
    return _expenseRepository
        .getExpenses(categoryId: categoryId)
        .map((expenses) {
      // sort by date
      expenses.sort((a, b) => b.created.compareTo(a.created));
      return expenses;
    });
  }
}
