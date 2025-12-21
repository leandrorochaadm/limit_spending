import '../../../../core/exceptions/exceptions.dart';
import '../repositories/account_repository.dart';
import 'increment_account_value_usecase.dart';

/// Use case para pagar dívida/cartão
/// Decrementa o valor da conta (pagando a dívida)
class PaymentAccountUseCase {
  final AccountRepository accountRepository;
  final IncrementAccountValueUseCase incrementAccountValueUseCase;

  PaymentAccountUseCase({
    required this.accountRepository,
    required this.incrementAccountValueUseCase,
  });

  Future<Failure?> call(
    String paymentAccountId,
    String debtAccountId,
    double valuePayment,
  ) async {
    try {
      // Incrementa o valor na conta de pagamento (debita)
      await incrementAccountValueUseCase(paymentAccountId, -valuePayment);

      // Decrementa o valor na conta de dívida (paga)
      await incrementAccountValueUseCase(debtAccountId, -valuePayment);

      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao realizar pagamento: $e');
    }
  }
}
