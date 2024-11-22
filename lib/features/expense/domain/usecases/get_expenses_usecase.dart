import '../../../expense/domain/domain.dart';

class GetExpensesUseCase {
  final ExpenseRepository _expenseRepository;

  GetExpensesUseCase(this._expenseRepository);
  Future<List<ExpenseEntity>> call(String categoryId) {
    return _expenseRepository
        .getExpenses(categoryId: categoryId)
        .then((expenses) {
      // sort by date
      expenses.sort((a, b) => b.created.compareTo(a.created));
      return expenses;
    });
  }
}
