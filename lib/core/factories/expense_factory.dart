import '../../features/category/domain/domain.dart';
import '../../features/expense/expense.dart';
import 'category_factory.dart';
import 'firestore_factory.dart';

ExpenseController expenseControllerFactory() {
  final expenseRepository = ExpenseFirebaseRepository(
    firestore: makeFirestore(),
    categoryRepository: makeCategoryRepository(),
  );

  final getExpensesUseCase = GetExpensesUseCase(expenseRepository);

  final createExpenseUseCase = CreateExpenseUseCase(expenseRepository);

  final updateExpenseUseCase = UpdateExpenseUseCase(expenseRepository);

  final deleteExpenseUseCase = DeleteExpenseUseCase(expenseRepository);

  final getExpensesByCreatedUseCase =
      GetExpensesByCreatedUseCase(expenseRepository);

  final CategoryRepository categoryRepository = makeCategoryRepository();

  final getCategoryByIdUseCase = GetCategoryByIdUseCase(categoryRepository);

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
