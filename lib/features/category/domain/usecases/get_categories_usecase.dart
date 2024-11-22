import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository _categoryRepository;
  GetCategoriesUseCase(this._categoryRepository);
  Future<(String?, List<CategoryEntity>)> call() async {
    List<CategoryEntity> categories = [];
    try {
      categories = await _categoryRepository.getCategories();
      categories.sort((a, b) => a.name.compareTo(b.name));
      return (null, categories);
    } catch (e) {
      return (e.toString(), categories);
    }
  }
}
