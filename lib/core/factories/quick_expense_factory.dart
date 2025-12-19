import '../../features/quick_expense/quick_expense.dart';
import 'category_factory.dart';
import 'expense_factory.dart';
import 'payment_method_factory.dart';

QuickExpenseController makeQuickExpenseController() {
  return QuickExpenseController(
    getCategoriesUseCase: makeGetCategoriesUseCase(),
    getPaymentMethodsUseCase: makeGetPaymentMethodsUseCase(),
    createTransactionUseCase: makeCreateTransactionUseCase(),
  );
}

QuickExpensePage makeQuickExpensePage() {
  return QuickExpensePage(
    controller: makeQuickExpenseController(),
  );
}
