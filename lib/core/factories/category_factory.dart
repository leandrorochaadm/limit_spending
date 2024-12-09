import '../../features/category/category.dart';
import '../../features/category/domain/usecases/get_sum_categories_usecase.dart';
import '../../features/expense/domain/usecases/get_expenses_by_created_usecase.dart';
import '../core.dart';
import 'firestore_factory.dart';

CategoryFirebaseRepository categoryRepositoryFactory() =>
    CategoryFirebaseRepository(makeFirestoreFactory());
GetCategoriesUseCase makeGetCategoriesUseCase() =>
    GetCategoriesUseCase(categoryRepositoryFactory());
CreateCategoryUseCase makeCreateCategoryUseCase() =>
    CreateCategoryUseCase(categoryRepositoryFactory());
UpdateCategoryUseCase makeUpdateCategoryUseCase() =>
    UpdateCategoryUseCase(categoryRepositoryFactory());
GetSumCategoriesUseCase makeSumCategoryUseCase() =>
    GetSumCategoriesUseCase(makeGetCategoriesUseCase());

final GetExpensesByDateCreatedUseCase getExpensesByCreatedUseCase =
    makeGetExpensesByDateCreatedUseCase();
final getCategoryByIdUseCase = makeGetCategoryByIdUseCase();

CategoryController categoryControllerFactory() {
  final categoryController = CategoryController(
    getCategoriesUseCase: makeGetCategoriesUseCase(),
    createCategoryUseCase: makeCreateCategoryUseCase(),
    updateCategoryUseCase: makeUpdateCategoryUseCase(),
    getSumCategoriesUseCase: makeSumCategoryUseCase(),
  );
  return categoryController;
}

CategoryPage makeCategoryPage(String paymentMethodId) => CategoryPage(
      categoryController: categoryControllerFactory(),
      paymentMethodId: paymentMethodId,
    );

Future<void> makeUpdateCategoryConsumedUseCase(
  String categoryId,
  double consumed,
) =>
    UpdateCategoryConsumedUseCase(categoryRepositoryFactory())
        .call(categoryId, consumed);
