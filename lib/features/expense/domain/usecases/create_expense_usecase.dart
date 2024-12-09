import '../../../../core/exceptions/exceptions.dart';
import '../../../debt/debit.dart';
import '../../../payment_method/payment_method.dart';
import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class CreateExpenseUseCase {
  final ExpenseRepository expenseRepository;

  final IncrementValuePaymentMethodUseCase incrementValuePaymentMethodUseCase;
  final AddDebtValueUseCase addDebtValueUseCase;

  CreateExpenseUseCase({
    required this.expenseRepository,
    required this.incrementValuePaymentMethodUseCase,
    required this.addDebtValueUseCase,
  });

  Future<Failure?> call(ExpenseEntity expenseEntity) async {
    try {
      await expenseRepository.createExpense(expenseEntity.toModel());

      await incrementValuePaymentMethodUseCase(
        paymentMethodId: expenseEntity.paymentMethodId,
        value: expenseEntity.value,
      );

      await addDebtValueUseCase(
        debtId: expenseEntity.paymentMethodId,
        debtValue: expenseEntity.value,
      );

      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao criar despesa');
    }
  }
}
