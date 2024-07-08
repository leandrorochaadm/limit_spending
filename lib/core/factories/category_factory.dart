import '../../features/category/category.dart';
import 'firestoreFactory.dart';

CategoryFirebaseRepository makeCategoryRepository() =>
    CategoryFirebaseRepository(makeFirestore());
GetCategoriesUseCase makeGetCategoriesUseCase() =>
    GetCategoriesUseCase(makeCategoryRepository());
CreateCategoryUseCase makeCreateCategoryUseCase() =>
    CreateCategoryUseCase(makeCategoryRepository());
UpdateCategoryUseCase makeUpdateCategoryUseCase() =>
    UpdateCategoryUseCase(makeCategoryRepository());
CategoryController categoryControllerFactory() {
  final categoryController = CategoryController(
    getCategoriesUseCase: makeGetCategoriesUseCase(),
    createCategoryUseCase: makeCreateCategoryUseCase(),
    updateCategoryUseCase: makeUpdateCategoryUseCase(),
  );
  return categoryController;
}
