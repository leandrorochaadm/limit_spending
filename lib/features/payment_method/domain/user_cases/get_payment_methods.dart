import '../domain.dart';

class GetPaymentMethodsUseCase {
  final PaymentMethodRepository repository;
  GetPaymentMethodsUseCase(this.repository);
  Future<(String?, List<PaymentMethodEntity>)> call() async {
    try {
      List<PaymentMethodEntity> paymentMethods =
          await repository.getPaymentMethods();

      paymentMethods.sort((a, b) {
        // Primeiro, ordenar por isMoney (true vem antes de false)
        if (a.isMoney != b.isMoney) {
          return a.isMoney ? -1 : 1;
        }
        // Se isMoney for igual, ordenar por name
        return a.name.compareTo(b.name);
      });

      return Future.value((null, paymentMethods));
    } catch (e) {
      return Future.value((e.toString(), <PaymentMethodEntity>[]));
    }
  }
}
