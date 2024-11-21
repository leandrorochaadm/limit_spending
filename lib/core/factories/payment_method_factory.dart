import '../../features/debt/domain/usecases/usecases.dart';
import '../../features/payment_method/payment_method.dart';
import 'debt_factory.dart';
import 'firestore_factory.dart';

PaymentMethodFirebaseRepository paymentMethodRepositoryFactory() =>
    PaymentMethodFirebaseRepository(makeFirestoreFactory());
CreateDebtByPaymentMethodCardUseCase
    makeCreateDebtByPaymentMethodCardUseCase() =>
        CreateDebtByPaymentMethodCardUseCase(makeCreateDebtUseCase());
GetPaymentMethodsUseCase makeGetPaymentMethodsUseCase() =>
    GetPaymentMethodsUseCase(
      repository: paymentMethodRepositoryFactory(),
      createDebtByPaymentMethodCardUseCase:
          makeCreateDebtByPaymentMethodCardUseCase(),
    );
CreatePaymentMethodUseCase makeCreatePaymentMethodUseCase() =>
    CreatePaymentMethodUseCase(paymentMethodRepositoryFactory());
UpdatePaymentMethodUseCase makeUpdatePaymentMethodUseCase() =>
    UpdatePaymentMethodUseCase(paymentMethodRepositoryFactory());

DeletePaymentMethodUseCase makeDeletePaymentMethodUseCase() =>
    DeletePaymentMethodUseCase(paymentMethodRepositoryFactory());

Future<String?> makeIncrementValuePaymentMethodUseCase({
  required String paymentMethodId,
  required double value,
}) =>
    IncrementValuePaymentMethodUseCase(paymentMethodRepositoryFactory())
        .call(paymentMethodId: paymentMethodId, value: value);

PaymentMethodNotifier paymentMethodNotifierFactory() {
  final paymentMethodNotifier = PaymentMethodNotifier(
    getPaymentMethodsUseCase: makeGetPaymentMethodsUseCase(),
    createPaymentMethodUseCase: makeCreatePaymentMethodUseCase(),
    updatePaymentMethodUseCase: makeUpdatePaymentMethodUseCase(),
    deletePaymentMethodUseCase: makeDeletePaymentMethodUseCase(),
  );
  return paymentMethodNotifier;
}

PaymentMethodPage makePaymentMethodPage() =>
    PaymentMethodPage(paymentMethodNotifierFactory());
