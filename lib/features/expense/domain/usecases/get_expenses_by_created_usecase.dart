import '../../../../core/factories/factories.dart';
import '../../../expense/domain/domain.dart';

class GetExpensesByDateCreatedUseCase {
  final ExpenseRepository _expenseRepository;

  GetExpensesByDateCreatedUseCase(this._expenseRepository);
  Future<List<ExpenseEntity>> call({
    required String categoryId,
    int days = 30,
  }) async {
    var expenses = await _expenseRepository.getExpensesByPeriodCreated(
      categoryId: categoryId,
      startDate: DateTime.now().subtract(Duration(days: days)),
      endDate: DateTime.now(),
    );

    expenses.sort((b, a) => b.created.compareTo(a.created));

    final consumedSum = expenses.fold<double>(
      0,
      (previousValue, expense) => previousValue + expense.value,
    );

    await makeUpdateCategoryConsumedUseCase(categoryId, consumedSum);

    return expenses;
  }
}
