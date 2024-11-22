import '../entity.dart';
import '../repositoy.dart';

class GetDebtsUseCase {
  final DebtRepository debtRepository;

  GetDebtsUseCase(this.debtRepository);
  Future<List<DebtEntity>> call() {
    return debtRepository.getDebts().then((debts) {
      debts.sort((a, b) => a.name.compareTo(b.name));
      return debts;
    });
  }
}
