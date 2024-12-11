import '../../../../core/exceptions/exceptions.dart';
import '../../../payment_method/domain/domain.dart';
import '../../debit.dart';

class PaymentDebitUseCase {
  final AddDebtValueUseCase addDebtValueUseCase;
  final IncrementValuePaymentMethodUseCase incrementValuePaymentMethodUseCase;

  PaymentDebitUseCase({
    required this.addDebtValueUseCase,
    required this.incrementValuePaymentMethodUseCase,
  });

  Future<Failure?> call(
    String paymentMethodId,
    String debtId,
    double value,
  ) async {
    try {
      await addDebtValueUseCase(debtId: debtId, debtValue: -value);

      await incrementValuePaymentMethodUseCase(
        paymentMethodId: paymentMethodId,
        value: -value,
      );
      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao pagar dívida');
    }
  }
}
