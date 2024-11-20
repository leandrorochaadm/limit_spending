import '../../features/payment_method/payment_method.dart';
import 'firestore_factory.dart';

PaymentMethodFirebaseRepository paymentMethodRepositoryFactory() =>
    PaymentMethodFirebaseRepository(makeFirestoreFactory());
GetPaymentMethodsUseCase makeGetPaymentMethodsUseCase() =>
    GetPaymentMethodsUseCase(paymentMethodRepositoryFactory());
CreatePaymentMethodUseCase makeCreatePaymentMethodUseCase() =>
    CreatePaymentMethodUseCase(paymentMethodRepositoryFactory());
UpdatePaymentMethodUseCase makeUpdatePaymentMethodUseCase() =>
    UpdatePaymentMethodUseCase(paymentMethodRepositoryFactory());

DeletePaymentMethodUseCase makeDeletePaymentMethodUseCase() =>
    DeletePaymentMethodUseCase(paymentMethodRepositoryFactory());

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
