import '../../data/data.dart';
import '../domain.dart';

abstract class ExpenseRepository {
  Stream<List<ExpenseEntity>> getExpenses();
  Future<void> createExpense(ExpenseModel expense);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(ExpenseModel expense);
}
