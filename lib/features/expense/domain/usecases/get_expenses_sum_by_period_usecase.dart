import '../repositories/expense_repository.dart';

class GetExpensesSumByPeriodUseCase {
  final ExpenseRepository _repository;
  GetExpensesSumByPeriodUseCase(this._repository);

  Future<double> call({required String categoryId, int days = 30}) {
    return _repository.getExpensesSumByPeriodCreated(
      categoryId: categoryId,
      startDate: DateTime.now().subtract(Duration(days: days)),
      endDate: DateTime.now(),
    );
  }
}
