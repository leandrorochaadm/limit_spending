import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/pagination/pagination.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoriesPaginatedUseCase {
  final CategoryRepository _categoryRepository;

  GetCategoriesPaginatedUseCase(this._categoryRepository);

  Future<(Failure?, PaginatedResult<CategoryEntity>)> call({
    required PaginationParams paginationParams,
  }) async {
    try {
      final result = await _categoryRepository.getCategoriesPaginated(
        paginationParams: paginationParams,
      );

      return (null, result);
    } on AppException catch (e) {
      return (Failure(e.message), PaginatedResult<CategoryEntity>.empty());
    } catch (e) {
      return (
        Failure('Erro ao buscar categorias: $e'),
        PaginatedResult<CategoryEntity>.empty(),
      );
    }
  }
}
