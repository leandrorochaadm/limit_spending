import '../../features/account/account.dart';
import 'expense_factory.dart';
import 'firestore_factory.dart';

AccountFirebaseRepository accountRepositoryFactory() =>
    AccountFirebaseRepository(makeFirestoreFactory());

GetAccountsUseCase makeGetAccountsUseCase() =>
    GetAccountsUseCase(accountRepositoryFactory());

GetAccountsPaginatedUseCase makeGetAccountsPaginatedUseCase() =>
    GetAccountsPaginatedUseCase(accountRepositoryFactory());

CreateAccountUseCase makeCreateAccountUseCase() =>
    CreateAccountUseCase(accountRepositoryFactory());

UpdateAccountUseCase makeUpdateAccountUseCase() =>
    UpdateAccountUseCase(accountRepositoryFactory());

IncrementAccountValueUseCase makeIncrementAccountValueUseCase() =>
    IncrementAccountValueUseCase(accountRepositoryFactory());

DeleteAccountUseCase makeDeleteAccountUseCase() => DeleteAccountUseCase(
      accountRepository: accountRepositoryFactory(),
      expenseRepository: makeExpenseRepository(),
    );

PaymentAccountUseCase makePaymentAccountUseCase() => PaymentAccountUseCase(
      accountRepository: accountRepositoryFactory(),
      incrementAccountValueUseCase: makeIncrementAccountValueUseCase(),
    );

AccountController accountControllerFactory() {
  final accountController = AccountController(
    createAccountUseCase: makeCreateAccountUseCase(),
    getAccountsUseCase: makeGetAccountsUseCase(),
    getAccountsPaginatedUseCase: makeGetAccountsPaginatedUseCase(),
    updateAccountUseCase: makeUpdateAccountUseCase(),
    deleteAccountUseCase: makeDeleteAccountUseCase(),
    incrementAccountValueUseCase: makeIncrementAccountValueUseCase(),
    paymentAccountUseCase: makePaymentAccountUseCase(),
  );
  return accountController;
}

AccountPage makeAccountPage() =>
    AccountPage(accountController: accountControllerFactory());
