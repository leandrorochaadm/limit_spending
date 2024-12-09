import '../../../../core/exceptions/exceptions.dart';
import '../repositoy.dart';

class AddDebtValueUseCase {
  final DebtRepository debtRepository;

  AddDebtValueUseCase(this.debtRepository);
  Future<Failure?> call({
    required String debtId,
    required double debtValue,
  }) async {
    try {
      await debtRepository.addDebtValue(debtId, debtValue);
      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao criar despesa');
    }
  }
}
