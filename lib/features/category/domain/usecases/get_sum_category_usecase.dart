import '../entities/entities.dart';
import '../repositories/category_repository.dart';

class GetSumCategoryUseCase {
  final CategoryRepository categoryRepository;
  GetSumCategoryUseCase(this.categoryRepository);
  Stream<CategorySumEntity> call(String categoryId) {
    return categoryRepository.getCategoryStream(categoryId).map(
      (category) {
        return CategorySumEntity(
          consumed: category.consumed,
          limit: category.limitMonthly,
        );
      },
    );
  }
}
