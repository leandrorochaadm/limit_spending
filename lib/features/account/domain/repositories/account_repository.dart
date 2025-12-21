import '../../../../core/pagination/pagination.dart';
import '../../data/models/account_model.dart';
import '../entities/account_entity.dart';
import '../entities/account_type.dart';

abstract class AccountRepository {
  // Create
  Future<void> createAccount(AccountModel account);

  // Read
  Future<List<AccountEntity>> getAccounts([bool isValueGreaterThanZero = true]);
  Future<AccountEntity?> getAccountById(String accountId);
  Future<List<AccountEntity>> getAccountsByType(
    AccountType type, [
    bool isValueGreaterThanZero = true,
  ]);
  Future<double> getSumAccounts();
  Future<PaginatedResult<AccountEntity>> getAccountsPaginated({
    required PaginationParams paginationParams,
  });

  // Update
  Future<void> updateAccount(AccountModel account);
  Future<void> incrementAccountValue(String accountId, double value);

  // Delete
  Future<void> deleteAccount(AccountEntity account);
}
