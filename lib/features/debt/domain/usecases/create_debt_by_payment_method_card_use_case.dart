import '../../../../core/exceptions/exceptions.dart';
import '../../../payment_method/domain/domain.dart';
import 'create_debt_usecase.dart';

class CreateDebtByPaymentMethodCardUseCase {
  final CreateDebtUseCase createDebtUseCase;

  CreateDebtByPaymentMethodCardUseCase(this.createDebtUseCase);
  Future<Failure?> call(PaymentMethodEntity paymentMethod) async {
    try {
      if (paymentMethod.isCard) {
        final failure = await createDebtUseCase(paymentMethod.toDebt());
        if (failure != null) {
          return Failure(
            'Erro ao criar dívida por metodo de pagamento: ${failure.message}',
          );
        }
        return null;
      }
      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao converter meio de pagamento para dívida');
    }
  }
}
