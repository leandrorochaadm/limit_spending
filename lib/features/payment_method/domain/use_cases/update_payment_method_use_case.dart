import '../domain.dart';

class UpdatePaymentMethodUseCase {
  final PaymentMethodRepository repository;

  UpdatePaymentMethodUseCase(this.repository);

  Future<String?> call(PaymentMethodEntity paymentMethod) async {
    try {
      await repository.updatePaymentMethod(paymentMethod);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
