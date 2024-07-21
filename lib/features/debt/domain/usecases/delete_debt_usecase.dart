import '../repositoy.dart';

class DeleteDebtUseCase {
  final DebtRepository debtRepository;

  DeleteDebtUseCase(this.debtRepository);
  Future<void> call(String debtId) {
    if (debtId.isEmpty) return Future.value();
    return debtRepository.deleteDebt(debtId);
  }
}
