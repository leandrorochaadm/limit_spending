import '../../features/category/category.dart';
import '../../features/expense/domain/usecases/get_expenses_by_created_usecase.dart';
import '../core.dart';
import 'firestore_factory.dart';

CategoryFirebaseRepository categoryRepositoryFactory() =>
    CategoryFirebaseRepository(firestoreFactory());
GetCategoriesUseCase makeGetCategoriesUseCase() =>
    GetCategoriesUseCase(categoryRepositoryFactory());
CreateCategoryUseCase makeCreateCategoryUseCase() =>
    CreateCategoryUseCase(categoryRepositoryFactory());
UpdateCategoryUseCase makeUpdateCategoryUseCase() =>
    UpdateCategoryUseCase(categoryRepositoryFactory());
GetSumCategoriesUseCase makeSumCategoryUseCase() =>
    GetSumCategoriesUseCase(makeGetCategoriesUseCase());

final GetExpensesByCreatedUseCase getExpensesByCreatedUseCase =
    getExpensesByCreatedUseCaseFactory();
final getCategoryByIdUseCase = getCategoryByIdUseCaseFactory();

GetSumCategoryUseCase getSumCategoryUseCase = GetSumCategoryUseCase(
  getExpensesByCreatedUseCase: getExpensesByCreatedUseCase,
  getCategoryByIdUseCase: getCategoryByIdUseCase,
);
CategoryController categoryControllerFactory() {
  final categoryController = CategoryController(
    getCategoriesUseCase: makeGetCategoriesUseCase(),
    createCategoryUseCase: makeCreateCategoryUseCase(),
    updateCategoryUseCase: makeUpdateCategoryUseCase(),
    getSumCategoriesUseCase: makeSumCategoryUseCase(),
    getSumCategoryUseCase: getSumCategoryUseCase,
  );
  return categoryController;
}
