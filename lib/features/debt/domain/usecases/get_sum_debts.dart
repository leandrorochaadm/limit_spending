import '../repositoy.dart';

class GetSumDebtsUseCase {
  final DebtRepository debtRepository;

  GetSumDebtsUseCase(this.debtRepository);
  Future<double> call() {
    return debtRepository.getSumDebts();
  }
}
