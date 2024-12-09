import '../../../../core/exceptions/exceptions.dart';
import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class CreateExpenseUseCase {
  final ExpenseRepository expenseRepository;

  CreateExpenseUseCase({required this.expenseRepository});

  Future<Failure?> call(ExpenseEntity expenseEntity) async {
    try {
      await expenseRepository.createExpense(expenseEntity.toModel());

      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao criar despesa');
    }
  }
}
