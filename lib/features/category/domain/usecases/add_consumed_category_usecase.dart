import '../../../../core/exceptions/exceptions.dart';
import '../repositories/category_repository.dart';

class AddConsumedCategoryUseCase {
  final CategoryRepository _categoryRepository;
  AddConsumedCategoryUseCase(this._categoryRepository);

  Future<Failure?> call(String categoryId, double consumed) async {
    try {
      await _categoryRepository.addConsumedCategory(categoryId, consumed);
      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao incrementar valor consumido na categoria');
    }
  }
}
