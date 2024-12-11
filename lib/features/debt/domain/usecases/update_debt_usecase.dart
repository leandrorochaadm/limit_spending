import '../../../../core/exceptions/exceptions.dart';
import '../entities/debt_entity.dart';
import '../repositoy.dart';

class UpdateDebitUseCase {
  final DebtRepository debtRepository;

  UpdateDebitUseCase(this.debtRepository);
  Future<Failure?> call(DebtEntity debt) async {
    try {
      await debtRepository.updateDebt(debt);
      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao criar despesa');
    }
  }
}
