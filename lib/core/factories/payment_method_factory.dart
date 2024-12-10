import '../../features/debt/domain/usecases/usecases.dart';
import '../../features/payment_method/payment_method.dart';
import 'debt_factory.dart';
import 'firestore_factory.dart';

PaymentMethodFirebaseRepository paymentMethodRepositoryFactory() =>
    PaymentMethodFirebaseRepository(makeFirestoreFactory());
CreateDebtByPaymentMethodCardUseCase
    makeCreateDebtByPaymentMethodCardUseCase() =>
        CreateDebtByPaymentMethodCardUseCase(makeCreateDebtUseCase());
GetAllPaymentMethodsUseCase makeGetPaymentMethodsUseCase() =>
    GetAllPaymentMethodsUseCase(paymentMethodRepositoryFactory());
CreatePaymentMethodUseCase makeCreatePaymentMethodUseCase() =>
    CreatePaymentMethodUseCase(paymentMethodRepositoryFactory());
UpdatePaymentMethodUseCase makeUpdatePaymentMethodUseCase() =>
    UpdatePaymentMethodUseCase(paymentMethodRepositoryFactory());

DeletePaymentMethodUseCase makeDeletePaymentMethodUseCase() =>
    DeletePaymentMethodUseCase(paymentMethodRepositoryFactory());

IncrementValuePaymentMethodUseCase makeIncrementValuePaymentMethodUseCase() =>
    IncrementValuePaymentMethodUseCase(paymentMethodRepositoryFactory());

GetMoneyPaymentMethodsUseCase makeGetMoneyPaymentMethodsUseCase() =>
    GetMoneyPaymentMethodsUseCase(paymentMethodRepositoryFactory());

PaymentMethodNotifier paymentMethodNotifierFactory([String? debtId]) {
  final paymentMethodNotifier = PaymentMethodNotifier(
    getPaymentMethodsUseCase: makeGetPaymentMethodsUseCase(),
    createPaymentMethodUseCase: makeCreatePaymentMethodUseCase(),
    updatePaymentMethodUseCase: makeUpdatePaymentMethodUseCase(),
    deletePaymentMethodUseCase: makeDeletePaymentMethodUseCase(),
    debtId: debtId,
    getMoneyPaymentMethodsUseCase: makeGetMoneyPaymentMethodsUseCase(),
    paymentDebitUseCase: makePaymentDebitUseCase(),
  );
  return paymentMethodNotifier;
}

PaymentMethodPage makePaymentMethodPage({String? debtId}) =>
    PaymentMethodPage(paymentMethodNotifierFactory(debtId));
