import '../../../../core/exceptions/exceptions.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoryByIdUseCase {
  final CategoryRepository categoryRepository;
  GetCategoryByIdUseCase(this.categoryRepository);
  Future<(Failure?, CategoryEntity)> call(String categoryId) async {
    try {
      final result = await categoryRepository.categoryById(categoryId);
      return (null, result);
    } on AppException catch (e) {
      return (Failure(e.message), CategoryEntity.empty());
    } catch (e) {
      return (
        Failure('Erro ao buscar por id a categoria'),
        CategoryEntity.empty()
      );
    }
  }
}
