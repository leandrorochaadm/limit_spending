import '../../../../core/exceptions/exceptions.dart';
import '../domain.dart';

class CreatePaymentMethodUseCase {
  final PaymentMethodRepository repository;

  CreatePaymentMethodUseCase(this.repository);

  Future<Failure?> call(PaymentMethodEntity paymentMethod) async {
    try {
      await repository.createPaymentMethod(paymentMethod);
      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao criar despesa');
    }
  }
}
