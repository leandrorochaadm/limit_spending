import '../../../../core/exceptions/exceptions.dart';
import '../../../debt/domain/usecases/usecases.dart';
import '../domain.dart';

class GetAllPaymentMethodsUseCase {
  final PaymentMethodRepository repository;
  final CreateDebtByPaymentMethodCardUseCase
      createDebtByPaymentMethodCardUseCase;

  GetAllPaymentMethodsUseCase({
    required this.repository,
    required this.createDebtByPaymentMethodCardUseCase,
  });
  Future<(Failure?, List<PaymentMethodEntity>)> call() async {
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

      return (null, paymentMethods);
    } on AppException catch (e) {
      return (Failure(e.message), <PaymentMethodEntity>[]);
    } catch (e) {
      return (
        Failure('Não foi possível carregar os meios de pagamento'),
        <PaymentMethodEntity>[]
      );
    }
  }
}
