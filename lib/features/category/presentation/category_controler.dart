import '../category.dart';

class CategoryController {
  final GetCategoriesUseCase getCategoriesUseCase;
  final CreateCategoryUseCase createCategoryUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;
  final GetSumCategoriesUseCase getSumCategoriesUseCase;
  final GetSumCategoryUseCase getSumCategoryUseCase;

  CategoryController({
    required this.getCategoriesUseCase,
    required this.createCategoryUseCase,
    required this.updateCategoryUseCase,
    required this.getSumCategoriesUseCase,
    required this.getSumCategoryUseCase,
  });

  Stream<List<CategoryEntity>> get categoriesStream {
    return getCategoriesUseCase();
  }

  void createCategory(CategoryEntity category) async {
    await createCategoryUseCase(category);
  }

  void updateCategory(CategoryEntity category) async {
    await updateCategoryUseCase(category);
  }

  Stream<CategorySumEntity> get sumCategories => getSumCategoriesUseCase();

  Stream<CategorySumEntity> getSumByCategory({
    required String categoryId,
    required double categoryLimit,
  }) =>
      getSumCategoryUseCase(
        categoryId: categoryId,
        limit: categoryLimit,
      );
}
