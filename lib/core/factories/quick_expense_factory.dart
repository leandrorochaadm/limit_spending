import '../../features/quick_expense/quick_expense.dart';
import 'account_factory.dart';
import 'category_factory.dart';
import 'expense_factory.dart';

QuickExpenseController makeQuickExpenseController() {
  return QuickExpenseController(
    getCategoriesUseCase: makeGetCategoriesUseCase(),
    getAccountsUseCase: makeGetAccountsUseCase(),
    createTransactionUseCase: makeCreateTransactionUseCase(),
  );
}

QuickExpensePage makeQuickExpensePage() {
  return QuickExpensePage(
    controller: makeQuickExpenseController(),
  );
}
