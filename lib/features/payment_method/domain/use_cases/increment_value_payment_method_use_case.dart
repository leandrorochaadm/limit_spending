import '../../../../core/exceptions/exceptions_custom.dart';
import '../../../../core/exceptions/failure.dart';
import '../domain.dart';

class IncrementValuePaymentMethodUseCase {
  final PaymentMethodRepository repository;

  IncrementValuePaymentMethodUseCase(this.repository);

  Future<Failure?> call({
    required String paymentMethodId,
    required double value,
  }) async {
    try {
      if (paymentMethodId.isEmpty) {
        return Failure('ID do meio de pagamento inválido');
      }

      await repository.incrementValuePaymentMethod(paymentMethodId, value);
      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao criar despesa');
    }
  }
}
