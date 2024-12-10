import '../../features/debt/domain/usecases/usecases.dart';
import '../../features/payment_method/domain/use_cases/get_card_payment_methods.dart';
import '../../features/payment_method/payment_method.dart';
import 'debt_factory.dart';
import 'firestore_factory.dart';

PaymentMethodFirebaseRepository makePaymentMethodRepository() =>
    PaymentMethodFirebaseRepository(makeFirestoreFactory());
CreateDebtByPaymentMethodCardUseCase
    makeCreateDebtByPaymentMethodCardUseCase() =>
        CreateDebtByPaymentMethodCardUseCase(makeCreateDebtUseCase());
GetAllPaymentMethodsUseCase makeGetPaymentMethodsUseCase() =>
    GetAllPaymentMethodsUseCase(makePaymentMethodRepository());
CreatePaymentMethodUseCase makeCreatePaymentMethodUseCase() =>
    CreatePaymentMethodUseCase(makePaymentMethodRepository());
UpdatePaymentMethodUseCase makeUpdatePaymentMethodUseCase() =>
    UpdatePaymentMethodUseCase(makePaymentMethodRepository());

DeletePaymentMethodUseCase makeDeletePaymentMethodUseCase() =>
    DeletePaymentMethodUseCase(makePaymentMethodRepository());

IncrementValuePaymentMethodUseCase makeIncrementValuePaymentMethodUseCase() =>
    IncrementValuePaymentMethodUseCase(makePaymentMethodRepository());

GetMoneyPaymentMethodsUseCase makeGetMoneyPaymentMethodsUseCase() =>
    GetMoneyPaymentMethodsUseCase(makePaymentMethodRepository());

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

GetCardPaymentMethodsUseCase makeGetCardPaymentMethodsUseCase() =>
    GetCardPaymentMethodsUseCase(makePaymentMethodRepository());
