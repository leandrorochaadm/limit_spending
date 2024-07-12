import '../../features/category/category.dart';
import 'firestore_factory.dart';

CategoryFirebaseRepository makeCategoryRepository() =>
    CategoryFirebaseRepository(makeFirestore());
GetCategoriesUseCase makeGetCategoriesUseCase() =>
    GetCategoriesUseCase(makeCategoryRepository());
CreateCategoryUseCase makeCreateCategoryUseCase() =>
    CreateCategoryUseCase(makeCategoryRepository());
UpdateCategoryUseCase makeUpdateCategoryUseCase() =>
    UpdateCategoryUseCase(makeCategoryRepository());
GetSumCategoriesUseCase makeSumCategoryUseCase() =>
    GetSumCategoriesUseCase(makeGetCategoriesUseCase());
CategoryController categoryControllerFactory() {
  final categoryController = CategoryController(
    getCategoriesUseCase: makeGetCategoriesUseCase(),
    createCategoryUseCase: makeCreateCategoryUseCase(),
    updateCategoryUseCase: makeUpdateCategoryUseCase(),
    getSumCategoriesUseCase: makeSumCategoryUseCase(),
  );
  return categoryController;
}
