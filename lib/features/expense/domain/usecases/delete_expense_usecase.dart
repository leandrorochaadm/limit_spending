import '../../../../core/exceptions/exceptions_custom.dart';
import '../../../../core/exceptions/failure.dart';
import '../repositories/expense_repository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository expenseRepository;

  DeleteExpenseUseCase({required this.expenseRepository});

  Future<Failure?> call(String expenseId) async {
    try {
      await expenseRepository.deleteExpense(expenseId);

      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao criar despesa');
    }
  }
}
