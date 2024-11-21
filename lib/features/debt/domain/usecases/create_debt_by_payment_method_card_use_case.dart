import '../../../payment_method/domain/domain.dart';
import 'create_debt_usecase.dart';

class CreateDebtByPaymentMethodCardUseCase {
  final CreateDebtUseCase createDebtUseCase;

  CreateDebtByPaymentMethodCardUseCase(this.createDebtUseCase);
  void call(PaymentMethodEntity paymentMethod) {
    if (paymentMethod.isCard && paymentMethod.value > 0) {
      createDebtUseCase(paymentMethod.toDebt());
    }
  }
}
