import '../domain.dart';

class CreatePaymentMethodUseCase {
  final PaymentMethodRepository repository;

  CreatePaymentMethodUseCase(this.repository);

  Future<String?> call(PaymentMethodEntity paymentMethod) async {
    try {
      await repository.createPaymentMethod(paymentMethod);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
