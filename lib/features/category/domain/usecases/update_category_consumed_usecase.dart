import '../repositories/category_repository.dart';

class UpdateCategoryConsumedUseCase {
  final CategoryRepository _categoryRepository;
  UpdateCategoryConsumedUseCase(this._categoryRepository);
  Future<void> call(String categoryId, double consumed) async =>
      await _categoryRepository.updateCategoryConsumed(categoryId, consumed);
}
