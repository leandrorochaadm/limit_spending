import '../../features/category/domain/domain.dart';
import '../../features/expense/expense.dart';
import '../use_case/create_transaction_use_case.dart';
import '../use_case/delete_transaction_use_case.dart';
import 'account_factory.dart';
import 'category_factory.dart';
import 'firestore_factory.dart';

ExpenseRepository makeExpenseRepository() => ExpenseFirebaseRepository(
      firestore: makeFirestoreFactory(),
      categoryRepository: categoryRepositoryFactory(),
    );
GetExpensesByDateCreatedUseCase makeGetExpensesByDateCreatedUseCase() =>
    GetExpensesByDateCreatedUseCase(makeExpenseRepository());

GetExpensesPaginatedUseCase makeGetExpensesPaginatedUseCase() =>
    GetExpensesPaginatedUseCase(makeExpenseRepository());

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
      incrementAccountValueUseCase: makeIncrementAccountValueUseCase(),
      createExpenseUseCase: makeCreateExpenseUseCase(),
      deleteExpenseUseCase: makeDeleteExpenseUseCase(),
    );

CreateTransactionUseCase makeCreateTransactionUseCase() =>
    CreateTransactionUseCase(
      incrementAccountValueUseCase: makeIncrementAccountValueUseCase(),
      createExpenseUseCase: makeCreateExpenseUseCase(),
      deleteExpenseUseCase: makeDeleteExpenseUseCase(),
    );

ExpenseController expenseControllerFactory({
  required CategoryEntity category,
  required String paymentMethodId,
  required bool isMoney,
  required Function? onGoBack,
}) {
  final ExpenseController expenseController = ExpenseController(
    createTransactionUseCase: makeCreateTransactionUseCase(),
    deleteTransactionUseCase: makeDeleteTransactionUseCase(),
    getExpensesByCreatedUseCase: makeGetExpensesByDateCreatedUseCase(),
    getExpensesPaginatedUseCase: makeGetExpensesPaginatedUseCase(),
    category: category,
    paymentMethodId: paymentMethodId,
    isMoney: isMoney,
    onGoBack: onGoBack,
  );

  return expenseController;
}

ExpensePage makeExpensePage({
  required CategoryEntity category,
  required String paymentMethodId,
  required bool isMoney,
  required Function? onGoBack,
}) =>
    ExpensePage(
      expenseControllerFactory(
        category: category,
        paymentMethodId: paymentMethodId,
        isMoney: isMoney,
        onGoBack: onGoBack,
      ),
    );
