import '../../../../core/exceptions/exceptions.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository _categoryRepository;
  GetCategoriesUseCase(this._categoryRepository);
  Future<(Failure?, List<CategoryEntity>)> call() async {
    List<CategoryEntity> categories = [];
    try {
      categories = await _categoryRepository.getCategories();
      categories.sort((a, b) => a.name.compareTo(b.name));
      return (null, categories);
    } on AppException catch (e) {
      return (Failure(e.message), <CategoryEntity>[]);
    } catch (e) {
      return (Failure('Erro carregar as categorias'), <CategoryEntity>[]);
    }
  }
}
