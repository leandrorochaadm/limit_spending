import '../../features/category/domain/domain.dart';
import '../../features/debt/domain/usecases/usecases.dart';
import '../../features/expense/expense.dart';
import 'category_factory.dart';
import 'debt_factory.dart';
import 'firestore_factory.dart';
import 'payment_method_factory.dart';

ExpenseFirebaseRepository expenseRepositoryFactory() =>
    ExpenseFirebaseRepository(
      firestore: makeFirestoreFactory(),
      categoryRepository: categoryRepositoryFactory(),
    );
GetExpensesByDateCreatedUseCase getExpensesByCreatedUseCaseFactory() =>
    GetExpensesByDateCreatedUseCase(expenseRepositoryFactory());

GetCategoryByIdUseCase getCategoryByIdUseCaseFactory() =>
    GetCategoryByIdUseCase(categoryRepositoryFactory());

ExpenseController expenseControllerFactory({
  required CategoryEntity category,
  required String paymentMethodId,
}) {
  final createExpenseUseCase = CreateExpenseUseCase(
    expenseRepository: expenseRepositoryFactory(),
    incrementValuePaymentMethodUseCase:
        makeIncrementValuePaymentMethodUseCase(),
    addDebtValueUseCase: makeAddDebtValueUseCase(),
  );

  final deleteExpenseUseCase = DeleteExpenseUseCase(
    expenseRepository: expenseRepositoryFactory(),
    incrementValuePaymentMethodUseCase:
        makeIncrementValuePaymentMethodUseCase(),
    addDebtValueUseCase: makeAddDebtValueUseCase(),
  );

  final getSumCategoryUseCase = GetSumCategoryUseCase(
    getExpensesByCreatedUseCase: getExpensesByCreatedUseCase,
    getCategoryByIdUseCase: getCategoryByIdUseCase,
  );

  final GetDebtsUseCase getDebtsUseCase = makeGetDebtsUseCase();
  final AddDebtValueUseCase addDebtValueUseCase = makeAddDebtValueUseCase();

  final ExpenseController expenseController = ExpenseController(
    createExpenseUseCase: createExpenseUseCase,
    deleteExpenseUseCase: deleteExpenseUseCase,
    getSumCategoryUseCase: getSumCategoryUseCase,
    getExpensesByCreatedUseCase: getExpensesByCreatedUseCase,
    getDebtsUseCase: getDebtsUseCase,
    addDebtValueUseCase: addDebtValueUseCase,
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
