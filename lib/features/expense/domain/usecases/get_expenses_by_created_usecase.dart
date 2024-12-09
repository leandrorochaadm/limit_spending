import '../../../../core/exceptions/exceptions_custom.dart';
import '../../../../core/exceptions/failure.dart';
import '../../../../core/factories/factories.dart';
import '../../../expense/domain/domain.dart';

class GetExpensesByDateCreatedUseCase {
  final ExpenseRepository _expenseRepository;

  GetExpensesByDateCreatedUseCase(this._expenseRepository);
  Future<(Failure?, List<ExpenseEntity>)> call({
    required String categoryId,
    int days = 30,
  }) async {
    try {
      final expenses = await _expenseRepository.getExpensesByPeriodCreated(
        categoryId: categoryId,
        startDate: DateTime.now().subtract(Duration(days: days)),
        endDate: DateTime.now(),
      );

      expenses.sort((a, b) => b.created.compareTo(a.created));

      final consumedSum = expenses.fold<double>(
        0,
        (previousValue, expense) => previousValue + expense.value,
      );

      await makeUpdateCategoryConsumedUseCase(categoryId, consumedSum);

      return (null, expenses);
    } on AppException catch (e) {
      return (Failure(e.message), <ExpenseEntity>[]);
    } catch (e) {
      return (Failure('Erro ao criar despesa'), <ExpenseEntity>[]);
    }
  }
}
