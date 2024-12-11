import '../../../../core/exceptions/exceptions.dart';
import '../repositoy.dart';

class DeleteDebtUseCase {
  final DebtRepository debtRepository;

  DeleteDebtUseCase(this.debtRepository);
  Future<Failure?> call(String debtId) async {
    if (debtId.isEmpty) return Future.value(Failure('ID da divida inválido'));
    try {
      await debtRepository.deleteDebt(debtId);
      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao pagar dívida');
    }
  }
}
