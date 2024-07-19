import '../../debit.dart';

class CreateDebtUseCase {
  final DebtRepository debtRepository;

  CreateDebtUseCase(this.debtRepository);
  Future<void> call(DebtEntity debt) async {
    debtRepository.createDebt(debt);
  }
}
