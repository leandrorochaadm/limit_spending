import '../../../../core/exceptions/exceptions.dart';
import '../domain.dart';

class GetAllPaymentMethodsUseCase {
  final PaymentMethodRepository repository;

  GetAllPaymentMethodsUseCase(this.repository);
  Future<(Failure?, List<PaymentMethodEntity>)> call(
    bool isValueGreaterThanZero,
  ) async {
    try {
      final List<PaymentMethodEntity> paymentMethods =
          await repository.getPaymentMethods();

      final filteredPaymentMethods = paymentMethods
          .where(
            (paymentMethod) =>
                (isValueGreaterThanZero ? paymentMethod.balance > 0 : true),
          )
          .toList();

      filteredPaymentMethods.sort((a, b) {
        // Primeiro, ordenar por isMoney (true vem antes de false)
        if (a.isMoney != b.isMoney) {
          return a.isMoney ? -1 : 1;
        }
        // Se isMoney for igual, ordenar por name
        return a.name.compareTo(b.name);
      });

      return (null, filteredPaymentMethods);
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
