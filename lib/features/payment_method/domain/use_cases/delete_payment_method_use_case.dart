import '../../../../core/exceptions/exceptions.dart';
import '../domain.dart';

class DeletePaymentMethodUseCase {
  final PaymentMethodRepository repository;

  DeletePaymentMethodUseCase(this.repository);

  Future<Failure?> call(PaymentMethodEntity paymentMethod) async {
    try {
      await repository.deletePaymentMethod(paymentMethod);
      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao criar despesa');
    }
  }
}
