import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/pagination/pagination.dart';
import '../entities/account_entity.dart';
import '../repositories/account_repository.dart';

class GetAccountsPaginatedUseCase {
  final AccountRepository repository;

  GetAccountsPaginatedUseCase(this.repository);

  Future<(Failure?, PaginatedResult<AccountEntity>)> call({
    required PaginationParams paginationParams,
  }) async {
    try {
      final result = await repository.getAccountsPaginated(
        paginationParams: paginationParams,
      );
      return (null, result);
    } on AppException catch (e) {
      return (
        Failure(e.message),
        PaginatedResult<AccountEntity>(
          items: [],
          hasMore: false,
          lastDocument: null,
        ),
      );
    } catch (e) {
      return (
        Failure('Erro ao buscar contas paginadas: $e'),
        PaginatedResult<AccountEntity>(
          items: [],
          hasMore: false,
          lastDocument: null,
        ),
      );
    }
  }
}
