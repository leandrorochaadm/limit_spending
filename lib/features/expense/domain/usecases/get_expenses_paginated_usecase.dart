import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/pagination/pagination.dart';
import '../domain.dart';

class GetExpensesPaginatedUseCase {
  final ExpenseRepository _expenseRepository;

  GetExpensesPaginatedUseCase(this._expenseRepository);

  /// Returns paginated expenses.
  /// Use [paginationParams] to control page size and cursor.
  Future<(Failure?, PaginatedResult<ExpenseEntity>)> call({
    required String categoryId,
    int days = 30,
    required PaginationParams paginationParams,
  }) async {
    try {
      final result = await _expenseRepository.getExpensesPaginated(
        categoryId: categoryId,
        startDate: DateTime.now().subtract(Duration(days: days)),
        endDate: DateTime.now(),
        paginationParams: paginationParams,
      );

      return (null, result);
    } on AppException catch (e) {
      return (Failure(e.message), PaginatedResult<ExpenseEntity>.empty());
    } catch (e) {
      return (
        Failure('Erro ao buscar despesas: $e'),
        PaginatedResult<ExpenseEntity>.empty(),
      );
    }
  }
}
