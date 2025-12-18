import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/pagination/pagination.dart';
import '../entities/debt_entity.dart';
import '../repositoy.dart';

class GetDebtsPaginatedUseCase {
  final DebtRepository _debtRepository;

  GetDebtsPaginatedUseCase(this._debtRepository);

  Future<(Failure?, PaginatedResult<DebtEntity>)> call({
    required PaginationParams paginationParams,
  }) async {
    try {
      final result = await _debtRepository.getDebtsPaginated(
        paginationParams: paginationParams,
      );

      return (null, result);
    } on AppException catch (e) {
      return (Failure(e.message), PaginatedResult<DebtEntity>.empty());
    } catch (e) {
      return (
        Failure('Erro ao buscar dívidas: $e'),
        PaginatedResult<DebtEntity>.empty(),
      );
    }
  }
}
