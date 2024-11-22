import '../domain.dart';

class GetMoneyPaymentMethodsUseCase {
  final PaymentMethodRepository repository;

  GetMoneyPaymentMethodsUseCase(this.repository);
  Future<(String?, List<PaymentMethodEntity>)> call() async {
    try {
      final List<PaymentMethodEntity> paymentMethods =
          await repository.getPaymentMethods();

      final filteredPaymentMethods = paymentMethods
          .where((paymentMethod) => paymentMethod.isMoney)
          .toList();

      filteredPaymentMethods.sort((a, b) {
        // Se isMoney for igual, ordenar por name
        return a.name.compareTo(b.name);
      });

      return Future.value((null, filteredPaymentMethods));
    } catch (e) {
      return Future.value((e.toString(), <PaymentMethodEntity>[]));
    }
  }
}
