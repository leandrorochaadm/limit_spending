import '../entity.dart';
import '../repositoy.dart';

class GetDebtsUseCase {
  final DebtRepository debtRepository;

  GetDebtsUseCase(this.debtRepository);
  Stream<List<DebtEntity>> call() {
    return debtRepository.getDebts();
  }
}
