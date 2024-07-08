import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository _categoryRepository;
  GetCategoriesUseCase(this._categoryRepository);
  Stream<List<CategoryEntity>> call() => _categoryRepository.getCategories();
}
