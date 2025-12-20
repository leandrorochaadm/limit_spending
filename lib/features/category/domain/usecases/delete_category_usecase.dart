import '../../../../core/exceptions/exceptions_custom.dart';
import '../../../../core/exceptions/failure.dart';
import '../../../expense/domain/repositories/expense_repository.dart';
import '../repositories/category_repository.dart';

class DeleteCategoryUseCase {
  final CategoryRepository _categoryRepository;
  final ExpenseRepository _expenseRepository;

  DeleteCategoryUseCase(
    this._categoryRepository,
    this._expenseRepository,
  );

  Future<Failure?> call(String categoryId) async {
    try {
      // Delete all expenses from category first
      await _expenseRepository.deleteExpensesByCategory(categoryId);
      // Then delete the category
      await _categoryRepository.deleteCategory(categoryId);
      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao excluir categoria');
    }
  }
}
