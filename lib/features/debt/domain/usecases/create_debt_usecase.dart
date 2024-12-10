import '../../../../core/exceptions/exceptions.dart';
import '../../debit.dart';

class CreateDebtUseCase {
  final DebtRepository debtRepository;

  CreateDebtUseCase(this.debtRepository);
  Future<Failure?> call(DebtEntity debt) async {
    try {
      debtRepository.createDebt(debt);

      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao criar divida');
    }
  }
}
