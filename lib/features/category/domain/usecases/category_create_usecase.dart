import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class CreateCategoryUseCase {
  final CategoryRepository _categoryRepository;
  CreateCategoryUseCase(this._categoryRepository);
  Future<void> call(CategoryEntity categoryEntity) async =>
      await _categoryRepository.createCategory(categoryEntity);
}
