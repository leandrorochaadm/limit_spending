import '../../features/category/category.dart';
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

final GetExpensesByDateCreatedUseCase getExpensesByCreatedUseCase =
    makeGetExpensesByDateCreatedUseCase();
final getCategoryByIdUseCase = makeGetCategoryByIdUseCase();

CategoryController categoryControllerFactory() {
  final categoryController = CategoryController(
    getCategoriesUseCase: makeGetCategoriesUseCase(),
    createCategoryUseCase: makeCreateCategoryUseCase(),
    updateCategoryUseCase: makeUpdateCategoryUseCase(),
  );
  return categoryController;
}

CategoryPage makeCategoryPage({
  required String paymentMethodId,
  required bool isMoney,
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
