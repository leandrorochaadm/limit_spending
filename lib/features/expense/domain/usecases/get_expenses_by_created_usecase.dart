import '../../../expense/domain/domain.dart';

class GetExpensesByCreatedUseCase {
  final ExpenseRepository _expenseRepository;

  GetExpensesByCreatedUseCase(this._expenseRepository);
  Future<List<ExpenseEntity>> call(
      {required String categoryId, int days = 30}) {
    return _expenseRepository.getExpensesByPeriodCreated(
      categoryId: categoryId,
      startDate: DateTime.now().subtract(Duration(days: days)),
      endDate: DateTime.now(),
    );
  }
}
