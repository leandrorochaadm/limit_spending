import '../../../../core/exceptions/exceptions.dart';
import '../repositories/category_repository.dart';

class UpdateCategoryConsumedUseCase {
  final CategoryRepository _categoryRepository;
  UpdateCategoryConsumedUseCase(this._categoryRepository);
  Future<Failure?> call(String categoryId, double consumed) async {
    try {
      await _categoryRepository.updateCategoryConsumed(categoryId, consumed);
      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao adicionar valor na categoria');
    }
  }
}
