import '../../../../core/exceptions/exceptions_custom.dart';
import '../../../../core/exceptions/failure.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class CreateCategoryUseCase {
  final CategoryRepository _categoryRepository;
  CreateCategoryUseCase(this._categoryRepository);
  Future<Failure?> call(CategoryEntity categoryEntity) async {
    try {
      await _categoryRepository.createCategory(categoryEntity);
      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao adicionar categoria');
    }
  }
}
