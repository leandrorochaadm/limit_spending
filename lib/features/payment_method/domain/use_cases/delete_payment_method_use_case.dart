import '../domain.dart';

class DeletePaymentMethodUseCase {
  final PaymentMethodRepository repository;

  DeletePaymentMethodUseCase(this.repository);

  Future<String?> call(PaymentMethodEntity paymentMethod) async {
    try {
      await repository.deletePaymentMethod(paymentMethod);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
