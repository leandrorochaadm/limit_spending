import '../../../expense/domain/domain.dart';

class GetExpensesByCreatedUseCase {
  final ExpenseRepository _expenseRepository;

  GetExpensesByCreatedUseCase(this._expenseRepository);
  Stream<List<ExpenseEntity>> call({
    required String categoryId,
    DateTime? startDate,
    required DateTime endDate,
  }) {
    return _expenseRepository.getExpensesByPeriodCreated(
      categoryId: categoryId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
