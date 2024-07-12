import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<void> createCategory(CategoryEntity category);
  Future<void> updateCategory(CategoryEntity category);
  Future<CategoryEntity> categoryById(String categoryId);
  Future<void> deleteCategory(String categoryId);
  Stream<List<CategoryEntity>> getCategories();
  Future<void> addConsumedCategory(String categoryId, double consumed);

  Stream<CategoryEntity> getCategoryStream(String categoryId);
}
