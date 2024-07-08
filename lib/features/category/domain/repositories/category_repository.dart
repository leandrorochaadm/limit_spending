import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<void> createCategory(CategoryEntity category);
  Future<void> updateCategory(CategoryEntity category);
  Future<void> deleteCategory(String categoryId);
  Stream<List<CategoryEntity>> getCategories();
}