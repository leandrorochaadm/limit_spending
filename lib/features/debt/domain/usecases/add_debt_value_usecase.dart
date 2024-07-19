import '../repositoy.dart';

class AddDebtValueUseCase {
  final DebtRepository debtRepository;

  AddDebtValueUseCase(this.debtRepository);
  Future<void> call(String debtId, double debtValue) {
    return debtRepository.addDebtValue(debtId, debtValue);
  }
}
