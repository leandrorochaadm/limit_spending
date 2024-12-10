import '../domain.dart';

abstract class PaymentMethodRepository {
  Future<List<PaymentMethodEntity>> getPaymentMethods();
  Future<PaymentMethodEntity?> getPaymentById(String id);
  Future<void> createPaymentMethod(PaymentMethodEntity paymentMethod);
  Future<void> deletePaymentMethod(PaymentMethodEntity paymentMethod);
  Future<void> updatePaymentMethod(PaymentMethodEntity paymentMethod);
  Future<void> incrementValuePaymentMethod(
    String paymentMethodId,
    double value,
  );
}
