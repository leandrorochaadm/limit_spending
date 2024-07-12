import '../../features/category/domain/domain.dart';
import '../../features/expense/expense.dart';
import 'category_factory.dart';
import 'firestore_factory.dart';

ExpenseFirebaseRepository expenseRepositoryFactory() =>
    ExpenseFirebaseRepository(
      firestore: firestoreFactory(),
      categoryRepository: categoryRepositoryFactory(),
    );
GetExpensesByCreatedUseCase getExpensesByCreatedUseCaseFactory() =>
    GetExpensesByCreatedUseCase(expenseRepositoryFactory());

GetCategoryByIdUseCase getCategoryByIdUseCaseFactory() =>
    GetCategoryByIdUseCase(categoryRepositoryFactory());
ExpenseController expenseControllerFactory() {
  final getExpensesUseCase = GetExpensesUseCase(expenseRepositoryFactory());

  final createExpenseUseCase = CreateExpenseUseCase(expenseRepositoryFactory());

  final updateExpenseUseCase = UpdateExpenseUseCase(expenseRepositoryFactory());

  final deleteExpenseUseCase = DeleteExpenseUseCase(expenseRepositoryFactory());

  final getSumCategoryUseCase = GetSumCategoryUseCase(
    getExpensesByCreatedUseCase: getExpensesByCreatedUseCase,
    getCategoryByIdUseCase: getCategoryByIdUseCase,
  );

  final expenseController = ExpenseController(
    getExpensesUseCase: getExpensesUseCase,
    createExpenseUseCase: createExpenseUseCase,
    updateExpenseUseCase: updateExpenseUseCase,
    deleteExpenseUseCase: deleteExpenseUseCase,
    getSumCategoryUseCase: getSumCategoryUseCase,
    getExpensesByCreatedUseCase: getExpensesByCreatedUseCase,
  );
  return expenseController;
}
