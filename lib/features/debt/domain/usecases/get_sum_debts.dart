import '../repositoy.dart';

class GetSumDebtsUseCase {
  final DebtRepository debtRepository;

  GetSumDebtsUseCase(this.debtRepository);
  Stream<double> call() {
    return debtRepository.getSumDebts();
  }
}
