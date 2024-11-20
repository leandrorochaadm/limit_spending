import '../../../../core/factories/factories.dart';
import '../../../expense/domain/domain.dart';

class GetExpensesByCreatedUseCase {
  final ExpenseRepository _expenseRepository;

  GetExpensesByCreatedUseCase(this._expenseRepository);
  Future<List<ExpenseEntity>> call({
    required String categoryId,
    int days = 30,
  }) async {
    final expenses = await _expenseRepository.getExpensesByPeriodCreated(
      categoryId: categoryId,
      startDate: DateTime.now().subtract(Duration(days: days)),
      endDate: DateTime.now(),
    );

    final consumedSum = expenses.fold<double>(
      0,
      (previousValue, expense) => previousValue + expense.value,
    );

    await makeUpdateCategoryConsumedUseCase(categoryId, consumedSum);

    return expenses;
  }
}
