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
  final expenseController = ExpenseController(
    getExpensesUseCase: getExpensesUseCase,
    createExpenseUseCase: createExpenseUseCase,
    updateExpenseUseCase: updateExpenseUseCase,
    deleteExpenseUseCase: deleteExpenseUseCase,
  );
  return expenseController;
}
