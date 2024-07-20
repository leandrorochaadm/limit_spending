import '../repositoy.dart';

class AddDebtValueUseCase {
  final DebtRepository debtRepository;

  AddDebtValueUseCase(this.debtRepository);
  Future<void> call(String debtId, double debtValue) {
    if (debtId.isEmpty) return Future.value();
    return debtRepository.addDebtValue(debtId, debtValue);
  }
}
