import '../../features/category/domain/domain.dart';
import '../../features/debt/domain/usecases/usecases.dart';
import '../../features/expense/expense.dart';
import 'category_factory.dart';
import 'debt_factory.dart';
import 'firestore_factory.dart';

ExpenseFirebaseRepository expenseRepositoryFactory() =>
    ExpenseFirebaseRepository(
      firestore: makeFirestoreFactory(),
      categoryRepository: categoryRepositoryFactory(),
    );
GetExpensesByCreatedUseCase getExpensesByCreatedUseCaseFactory() =>
    GetExpensesByCreatedUseCase(expenseRepositoryFactory());

GetCategoryByIdUseCase getCategoryByIdUseCaseFactory() =>
    GetCategoryByIdUseCase(categoryRepositoryFactory());
ExpenseController expenseControllerFactory() {
  final createExpenseUseCase = CreateExpenseUseCase(expenseRepositoryFactory());

  final updateExpenseUseCase = UpdateExpenseUseCase(expenseRepositoryFactory());

  final deleteExpenseUseCase = DeleteExpenseUseCase(expenseRepositoryFactory());

  final getSumCategoryUseCase = GetSumCategoryUseCase(
    getExpensesByCreatedUseCase: getExpensesByCreatedUseCase,
    getCategoryByIdUseCase: getCategoryByIdUseCase,
  );

  final GetDebtsUseCase getDebtsUseCase = makeGetDebtsUseCase();
  final AddDebtValueUseCase addDebtValueUseCase = makeAddDebtValueUseCase();

  final ExpenseController expenseController = ExpenseController(
    createExpenseUseCase: createExpenseUseCase,
    updateExpenseUseCase: updateExpenseUseCase,
    deleteExpenseUseCase: deleteExpenseUseCase,
    getSumCategoryUseCase: getSumCategoryUseCase,
    getExpensesByCreatedUseCase: getExpensesByCreatedUseCase,
    getDebtsUseCase: getDebtsUseCase,
    addDebtValueUseCase: addDebtValueUseCase,
  );

  return expenseController;
}
