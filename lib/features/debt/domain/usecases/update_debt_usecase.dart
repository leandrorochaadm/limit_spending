import '../entity.dart';
import '../repositoy.dart';

class UpdateDebitUseCase {
  final DebtRepository debtRepository;

  UpdateDebitUseCase(this.debtRepository);
  Future<void> call(DebtEntity debt) {
    return debtRepository.updateDebt(debt);
  }
}
