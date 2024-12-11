import '../../../../core/exceptions/exceptions_custom.dart';
import '../../../../core/exceptions/failure.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class UpdateCategoryUseCase {
  final CategoryRepository _categoryRepository;
  UpdateCategoryUseCase(this._categoryRepository);
  Future<Failure?> call(CategoryEntity categoryEntity) async {
    try {
      await _categoryRepository.updateCategory(categoryEntity);
      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro atualizar categoria');
    }
  }
}
