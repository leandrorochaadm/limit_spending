import '../../../../core/exceptions/exceptions.dart';
import '../domain.dart';

class GetPaymentMethodsByIdUseCase {
  final PaymentMethodRepository repository;

  GetPaymentMethodsByIdUseCase(this.repository);
  Future<(Failure?, PaymentMethodEntity?)> call(String id) async {
    try {
      final PaymentMethodEntity? paymentMethod =
          await repository.getPaymentById(id);
      return (null, paymentMethod);
    } on AppException catch (e) {
      return (Failure(e.message), null);
    } catch (e) {
      return (
        Failure('Não foi possível carregar os meios de pagamento'),
        null
      );
    }
  }
}
