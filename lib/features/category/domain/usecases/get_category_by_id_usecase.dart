import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoryByIdUseCase {
  final CategoryRepository categoryRepository;
  GetCategoryByIdUseCase(this.categoryRepository);
  Future<CategoryEntity> call(String categoryId) =>
      categoryRepository.categoryById(categoryId);
}
