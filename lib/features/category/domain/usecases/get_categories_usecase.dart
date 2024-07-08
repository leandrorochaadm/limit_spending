import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository _categoryRepository;
  GetCategoriesUseCase(this._categoryRepository);
  Stream<List<CategoryEntity>> call() {
    return _categoryRepository.getCategories().map((categories) {
      // sort by name
      categories.sort((a, b) => a.name.compareTo(b.name));
      return categories;
    });
  }
}
