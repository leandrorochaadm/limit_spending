import '../../../expense/domain/usecases/usecases.dart';
import '../entities/entities.dart';
import 'get_category_by_id_usecase.dart';

class GetSumCategoryUseCase {
  final GetExpensesByCreatedUseCase getExpensesByCreatedUseCase;
  final GetCategoryByIdUseCase getCategoryByIdUseCase;
  GetSumCategoryUseCase({
    required this.getExpensesByCreatedUseCase,
    required this.getCategoryByIdUseCase,
  });
  Stream<CategorySumEntity> call({
    required String categoryId,
    required double limit,
  }) {
    return getExpensesByCreatedUseCase(
      categoryId: categoryId,
      endDate: DateTime.now().add(const Duration(days: 30)),
    ).map((expenses) {
      double totalConsumed =
          expenses.fold(0, (sum, expense) => sum + expense.value);
      double balance = limit - totalConsumed;
      return CategorySumEntity(
        consumed: totalConsumed,
        limit: limit,
        balance: balance,
      );
    });
  }
}
