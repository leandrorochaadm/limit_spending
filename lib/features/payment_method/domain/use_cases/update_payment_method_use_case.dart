import '../../../../core/exceptions/exceptions_custom.dart';
import '../../../../core/exceptions/failure.dart';
import '../domain.dart';

class UpdatePaymentMethodUseCase {
  final PaymentMethodRepository repository;

  UpdatePaymentMethodUseCase(this.repository);

  Future<Failure?> call(PaymentMethodEntity paymentMethod) async {
    try {
      await repository.updatePaymentMethod(paymentMethod);
      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao criar despesa');
    }
  }
}
