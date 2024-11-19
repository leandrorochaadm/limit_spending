import '../../data/data.dart';
import '../domain.dart';

abstract class ExpenseRepository {
  Future<List<ExpenseEntity>> getExpenses({required String categoryId});
  Future<void> createExpense(ExpenseModel expense);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(ExpenseModel expense);
  Future<List<ExpenseEntity>> getExpensesByPeriodCreated({
    required String categoryId,
    DateTime? startDate,
    required DateTime endDate,
  });
}
