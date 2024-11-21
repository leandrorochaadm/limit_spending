import '../../../debt/domain/usecases/usecases.dart';
import '../domain.dart';

class GetPaymentMethodsUseCase {
  final PaymentMethodRepository repository;
  final CreateDebtByPaymentMethodCardUseCase
      createDebtByPaymentMethodCardUseCase;

  GetPaymentMethodsUseCase({
    required this.repository,
    required this.createDebtByPaymentMethodCardUseCase,
  });
  Future<(String?, List<PaymentMethodEntity>)> call() async {
    try {
      final List<PaymentMethodEntity> paymentMethods =
          await repository.getPaymentMethods();

      paymentMethods.sort((a, b) {
        // Primeiro, ordenar por isMoney (true vem antes de false)
        if (a.isMoney != b.isMoney) {
          return a.isMoney ? -1 : 1;
        }
        // Se isMoney for igual, ordenar por name
        return a.name.compareTo(b.name);
      });

      if (paymentMethods.isNotEmpty) {
        for (final paymentMethod in paymentMethods) {
          createDebtByPaymentMethodCardUseCase(paymentMethod);
        }
      }

      return Future.value((null, paymentMethods));
    } catch (e) {
      return Future.value((e.toString(), <PaymentMethodEntity>[]));
    }
  }
}
