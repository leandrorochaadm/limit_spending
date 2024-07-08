import '../../features/expense/expense.dart';
import 'category_factory.dart';
import 'firestoreFactory.dart';

ExpenseController expenseControllerFactory() {
  final expenseRepository =
      ExpenseFirebaseRepository(firestore: makeFirestore());
  final getExpensesUseCase = GetExpensesUseCase(expenseRepository);
  final createExpenseUseCase = CreateExpenseUseCase(expenseRepository);
  final updateExpenseUseCase = UpdateExpenseUseCase(expenseRepository);
  final deleteExpenseUseCase = DeleteExpenseUseCase(expenseRepository);
  final expenseController = ExpenseController(
    getExpensesUseCase: getExpensesUseCase,
    createExpenseUseCase: createExpenseUseCase,
    updateExpenseUseCase: updateExpenseUseCase,
    deleteExpenseUseCase: deleteExpenseUseCase,
    getCategoriesUseCase: makeGetCategoriesUseCase(),
  );
  return expenseController;
}
