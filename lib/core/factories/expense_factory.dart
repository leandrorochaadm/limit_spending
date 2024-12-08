import '../../features/category/domain/domain.dart';
import '../../features/expense/expense.dart';
import '../use_case/create_transaction_use_case.dart';
import '../use_case/delete_transaction_use_case.dart';
import 'category_factory.dart';
import 'debt_factory.dart';
import 'firestore_factory.dart';
import 'payment_method_factory.dart';

ExpenseRepository makeExpenseRepository() => ExpenseFirebaseRepository(
      firestore: makeFirestoreFactory(),
      categoryRepository: categoryRepositoryFactory(),
    );
GetExpensesByDateCreatedUseCase makeGetExpensesByDateCreatedUseCase() =>
    GetExpensesByDateCreatedUseCase(makeExpenseRepository());

GetCategoryByIdUseCase makeGetCategoryByIdUseCase() =>
    GetCategoryByIdUseCase(categoryRepositoryFactory());

CreateExpenseUseCase makeCreateExpenseUseCase() {
  return CreateExpenseUseCase(expenseRepository: makeExpenseRepository());
}

DeleteExpenseUseCase makeDeleteExpenseUseCase() {
  return DeleteExpenseUseCase(expenseRepository: makeExpenseRepository());
}

DeleteTransactionUseCase makeDeleteTransactionUseCase() =>
    DeleteTransactionUseCase(
      incrementValuePaymentMethodUseCase:
          makeIncrementValuePaymentMethodUseCase(),
      addDebtValueUseCase: makeAddDebtValueUseCase(),
      createExpenseUseCase: makeCreateExpenseUseCase(),
      deleteExpenseUseCase: makeDeleteExpenseUseCase(),
    );

CreateTransactionUseCase makeCreateTransactionUseCase() =>
    CreateTransactionUseCase(
      incrementValuePaymentMethodUseCase:
          makeIncrementValuePaymentMethodUseCase(),
      addDebtValueUseCase: makeAddDebtValueUseCase(),
      createExpenseUseCase: makeCreateExpenseUseCase(),
      deleteExpenseUseCase: makeDeleteExpenseUseCase(),
    );

ExpenseController expenseControllerFactory({
  required CategoryEntity category,
  required String paymentMethodId,
}) {
  final ExpenseController expenseController = ExpenseController(
    createTransactionUseCase: makeCreateTransactionUseCase(),
    deleteTransactionUseCase: makeDeleteTransactionUseCase(),
    getExpensesByCreatedUseCase: getExpensesByCreatedUseCase,
    category: category,
    paymentMethodId: paymentMethodId,
  );

  return expenseController;
}

ExpensePage makeExpensePage({
  required CategoryEntity category,
  required String paymentMethodId,
}) =>
    ExpensePage(
      expenseControllerFactory(
        category: category,
        paymentMethodId: paymentMethodId,
      ),
    );
