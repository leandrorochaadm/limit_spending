import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/expense/expense.dart';

ExpenseController expenseControllerFactory(FirebaseFirestore firestore) {
  final expenseRepository = ExpenseFirebaseRepository(firestore: firestore);
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
