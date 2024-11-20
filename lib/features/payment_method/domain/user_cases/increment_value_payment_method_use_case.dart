import '../domain.dart';

class IncrementValuePaymentMethodUseCase {
  final PaymentMethodRepository repository;

  IncrementValuePaymentMethodUseCase(this.repository);

  Future<String?> call({
    required String paymentMethodId,
    required double value,
  }) async {
    try {
      await repository.incrementValuePaymentMethod(paymentMethodId, value);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
