import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/pagination/pagination.dart';
import '../../../../core/services/logger_services.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/entities/account_type.dart';
import '../../domain/repositories/account_repository.dart';
import '../models/account_model.dart';

class AccountFirebaseRepository implements AccountRepository {
  static const collectionPath = 'accounts';
  final FirebaseFirestore firestore;

  AccountFirebaseRepository(this.firestore);

  @override
  Future<void> createAccount(AccountModel account) async {
    try {
      await firestore
          .collection(collectionPath)
          .doc(account.id)
          .set(account.toJson());
    } on FirebaseException catch (e) {
      throw AppExceptionUtils.handleFirebaseError(e);
    } catch (e, s) {
      LoggerService.error('createAccount', e, s);
      rethrow;
    }
  }

  @override
  Future<List<AccountEntity>> getAccounts([
    bool isValueGreaterThanZero = true,
  ]) async {
    try {
      Query<Map<String, dynamic>> query = firestore
          .collection(collectionPath)
          .orderBy('name', descending: false);

      if (isValueGreaterThanZero) {
        query = query.where('value', isGreaterThan: 0);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => AccountModel.fromJson(doc.data()).toEntity())
          .toList();
    } on FirebaseException catch (e) {
      throw AppExceptionUtils.handleFirebaseError(e);
    } catch (e, s) {
      LoggerService.error('getAccounts', e, s);
      rethrow;
    }
  }

  @override
  Future<AccountEntity?> getAccountById(String accountId) async {
    try {
      final doc =
          await firestore.collection(collectionPath).doc(accountId).get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return AccountModel.fromJson(doc.data()!).toEntity();
    } on FirebaseException catch (e) {
      throw AppExceptionUtils.handleFirebaseError(e);
    } catch (e, s) {
      LoggerService.error('getAccountById', e, s);
      rethrow;
    }
  }

  @override
  Future<List<AccountEntity>> getAccountsByType(
    AccountType type, [
    bool isValueGreaterThanZero = true,
  ]) async {
    try {
      Query<Map<String, dynamic>> query = firestore
          .collection(collectionPath)
          .where('type', isEqualTo: type.name)
          .orderBy('name', descending: false);

      if (isValueGreaterThanZero) {
        query = query.where('value', isGreaterThan: 0);
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => AccountModel.fromJson(doc.data()).toEntity())
          .toList();
    } on FirebaseException catch (e) {
      throw AppExceptionUtils.handleFirebaseError(e);
    } catch (e, s) {
      LoggerService.error('getAccountsByType', e, s);
      rethrow;
    }
  }

  @override
  Future<double> getSumAccounts() async {
    try {
      final snapshot = await firestore.collection(collectionPath).get();

      return snapshot.docs.fold<double>(
        0,
        (sum, doc) {
          final account = AccountModel.fromJson(doc.data());
          return sum + account.value;
        },
      );
    } on FirebaseException catch (e) {
      throw AppExceptionUtils.handleFirebaseError(e);
    } catch (e, s) {
      LoggerService.error('getSumAccounts', e, s);
      rethrow;
    }
  }

  @override
  Future<PaginatedResult<AccountEntity>> getAccountsPaginated({
    required PaginationParams paginationParams,
  }) async {
    try {
      Query<Map<String, dynamic>> query = firestore
          .collection(collectionPath)
          .orderBy('name', descending: false);

      // Apply cursor pagination
      if (paginationParams.startAfterDocument != null) {
        query = query.startAfterDocument(paginationParams.startAfterDocument!);
      }

      // Apply limit (fetch one extra to check if there are more)
      query = query.limit(paginationParams.pageSize + 1);

      // Execute query
      final snapshot = await query.get();
      final docs = snapshot.docs;

      // Check if there are more results
      final hasMore = docs.length > paginationParams.pageSize;

      // Get actual items (remove extra if present)
      final actualDocs =
          hasMore ? docs.sublist(0, paginationParams.pageSize) : docs;

      // Map to entities
      final items = actualDocs
          .map((doc) => AccountModel.fromJson(doc.data()).toEntity())
          .toList();

      // Get last document for cursor
      final lastDocument = actualDocs.isNotEmpty ? actualDocs.last : null;

      return PaginatedResult<AccountEntity>(
        items: items,
        lastDocument: lastDocument,
        hasMore: hasMore,
      );
    } on FirebaseException catch (e) {
      throw AppExceptionUtils.handleFirebaseError(e);
    } catch (e, s) {
      LoggerService.error('getAccountsPaginated', e, s);
      rethrow;
    }
  }

  @override
  Future<void> updateAccount(AccountModel account) async {
    try {
      await firestore
          .collection(collectionPath)
          .doc(account.id)
          .update(account.toJson());
    } on FirebaseException catch (e) {
      throw AppExceptionUtils.handleFirebaseError(e);
    } catch (e, s) {
      LoggerService.error('updateAccount', e, s);
      rethrow;
    }
  }

  @override
  Future<void> incrementAccountValue(String accountId, double value) async {
    try {
      await firestore.collection(collectionPath).doc(accountId).update({
        'value': FieldValue.increment(value),
      });
    } on FirebaseException catch (e) {
      throw AppExceptionUtils.handleFirebaseError(e);
    } catch (e, s) {
      LoggerService.error('incrementAccountValue', e, s);
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount(AccountEntity account) async {
    try {
      await firestore.collection(collectionPath).doc(account.id).delete();
    } on FirebaseException catch (e) {
      throw AppExceptionUtils.handleFirebaseError(e);
    } catch (e, s) {
      LoggerService.error('deleteAccount', e, s);
      rethrow;
    }
  }
}
