import '../../../../core/exceptions/exceptions.dart';
import '../../debit.dart';

class GetDebtsUseCase {
  final DebtRepository debtRepository;

  GetDebtsUseCase(this.debtRepository);
  Future<(Failure?, List<DebtEntity>)> call() async {
    try {
      final debts = await debtRepository.getDebts().then((debts) {
        debts.sort((a, b) => a.name.compareTo(b.name));
        return debts;
      });

      return (null, debts); // Sucesso
    } on AppException catch (e) {
      return (Failure(e.message), <DebtEntity>[]);
    } catch (_) {
      return (Failure('Erro ao carregar as dívidas'), <DebtEntity>[]);
    }
  }
}
