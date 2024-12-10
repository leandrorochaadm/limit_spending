import '../../../../core/exceptions/exceptions.dart';
import '../domain.dart';

class GetCardPaymentMethodsUseCase {
  final PaymentMethodRepository repository;

  GetCardPaymentMethodsUseCase(this.repository);
  Future<(Failure?, List<PaymentMethodEntity>)> call([
    bool isValueGreaterThanZero = true,
  ]) async {
    try {
      final List<PaymentMethodEntity> paymentMethods =
          await repository.getPaymentMethods();

      final filteredPaymentMethods = paymentMethods
          .where(
            (paymentMethod) =>
                paymentMethod.isCard &&
                (isValueGreaterThanZero ? paymentMethod.value > 0 : true),
          )
          .toList();

      filteredPaymentMethods.sort((a, b) {
        // Se isCard for igual, ordenar por name
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
