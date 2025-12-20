import '../../features/category/category.dart';
import '../../features/expense/domain/usecases/get_expenses_by_created_usecase.dart';
import '../core.dart';
import 'expense_factory.dart';
import 'firestore_factory.dart';

CategoryFirebaseRepository categoryRepositoryFactory() =>
    CategoryFirebaseRepository(makeFirestoreFactory());
GetCategoriesUseCase makeGetCategoriesUseCase() =>
    GetCategoriesUseCase(categoryRepositoryFactory());
GetCategoriesPaginatedUseCase makeGetCategoriesPaginatedUseCase() =>
    GetCategoriesPaginatedUseCase(categoryRepositoryFactory());
CreateCategoryUseCase makeCreateCategoryUseCase() =>
    CreateCategoryUseCase(categoryRepositoryFactory());
UpdateCategoryUseCase makeUpdateCategoryUseCase() =>
    UpdateCategoryUseCase(categoryRepositoryFactory());
DeleteCategoryUseCase makeDeleteCategoryUseCase() => DeleteCategoryUseCase(
      categoryRepositoryFactory(),
      makeExpenseRepository(),
    );

final GetExpensesByDateCreatedUseCase getExpensesByCreatedUseCase =
    makeGetExpensesByDateCreatedUseCase();
final getCategoryByIdUseCase = makeGetCategoryByIdUseCase();

CategoryController categoryControllerFactory() {
  final categoryController = CategoryController(
    getCategoriesUseCase: makeGetCategoriesUseCase(),
    getCategoriesPaginatedUseCase: makeGetCategoriesPaginatedUseCase(),
    createCategoryUseCase: makeCreateCategoryUseCase(),
    updateCategoryUseCase: makeUpdateCategoryUseCase(),
    deleteCategoryUseCase: makeDeleteCategoryUseCase(),
  );
  return categoryController;
}

CategoryPage makeCategoryPage({
  String? paymentMethodId,
  bool? isMoney,
}) =>
    CategoryPage(
      categoryController: categoryControllerFactory(),
      paymentMethodId: paymentMethodId,
      isMoney: isMoney,
    );

Future<void> makeUpdateCategoryConsumedUseCase(
  String categoryId,
  double consumed,
) =>
    UpdateCategoryConsumedUseCase(categoryRepositoryFactory())
        .call(categoryId, consumed);
