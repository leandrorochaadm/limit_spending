import '../entity.dart';
import '../repositoy.dart';

class GetDebtsUseCase {
  final DebtRepository debtRepository;

  GetDebtsUseCase(this.debtRepository);
  Stream<List<DebtEntity>> call() {
    return debtRepository.getDebts().map((debts) {
      debts.sort((a, b) => a.name.compareTo(b.name));
      return debts;
    });
  }
}
