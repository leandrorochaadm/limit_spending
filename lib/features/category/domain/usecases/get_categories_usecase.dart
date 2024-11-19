import '../entities/categories_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository _categoryRepository;
  GetCategoriesUseCase(this._categoryRepository);
  Stream<CategoriesEntity> call() {
    return _categoryRepository.getCategories().map((categories) {
      // sort by name
      categories.sort((a, b) => a.name.compareTo(b.name));
      return CategoriesEntity(categories: categories);
    });
  }
}
