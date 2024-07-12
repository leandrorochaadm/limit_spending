import '../../../expense/domain/domain.dart';

class GetExpensesByCreatedUseCase {
  final ExpenseRepository _expenseRepository;

  GetExpensesByCreatedUseCase(this._expenseRepository);
  Stream<List<ExpenseEntity>> call({required String categoryId}) {
    return _expenseRepository.getExpensesByPeriodCreated(
      categoryId: categoryId,
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now(),
    );
  }
}
