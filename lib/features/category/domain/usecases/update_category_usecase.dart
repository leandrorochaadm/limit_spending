import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class UpdateCategoryUseCase {
  final CategoryRepository _categoryRepository;
  UpdateCategoryUseCase(this._categoryRepository);
  Future<void> call(CategoryEntity categoryEntity) async =>
      await _categoryRepository.updateCategory(categoryEntity);
}
