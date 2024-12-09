import '../../../../core/exceptions/exceptions.dart';
import '../domain.dart';

class GetMoneyPaymentMethodsUseCase {
  final PaymentMethodRepository repository;

  GetMoneyPaymentMethodsUseCase(this.repository);
  Future<(Failure?, List<PaymentMethodEntity>)> call() async {
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

      return (null, filteredPaymentMethods);
    } on AppException catch (e) {
      return (Failure(e.message), <PaymentMethodEntity>[]);
    } catch (e) {
      return (
        Failure('Erro ao buscar meios de pagamento'),
        <PaymentMethodEntity>[]
      );
    }
  }
}
