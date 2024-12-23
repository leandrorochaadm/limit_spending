import '../entities/entities.dart';
import 'get_categories_usecase.dart';

class GetSumCategoriesUseCase {
  final GetCategoriesUseCase getCategoriesUseCase;
  GetSumCategoriesUseCase(this.getCategoriesUseCase);
  Future<CategorySumEntity> call() async {
    final (_, categoryList) = await getCategoriesUseCase();

    final totalConsumed = categoryList.fold<double>(
      0,
      (previousValue, category) => previousValue + category.consumed,
    );

    final totalLimit = categoryList.fold<double>(
      0,
      (previousValue, category) => previousValue + category.limitMonthly,
    );

    final totalBalance = categoryList.fold<double>(
      0,
      (previousValue, category) => previousValue + category.balance,
    );

    return CategorySumEntity(
      consumed: totalConsumed,
      limit: totalLimit,
      balance: totalBalance,
    );
  }
}
