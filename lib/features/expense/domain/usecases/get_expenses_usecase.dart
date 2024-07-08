import '../../../expense/domain/domain.dart';

class GetExpensesUseCase {
  final ExpenseRepository _expenseRepository;
  GetExpensesUseCase(this._expenseRepository);
  Stream<List<ExpenseEntity>> call() {
    return _expenseRepository.getExpenses().map((expenses) {
      // sort by date
      expenses.sort((a, b) => a.created.compareTo(b.created));
      return expenses;
    });
  }
}
