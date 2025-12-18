import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/pagination/pagination.dart';
import '../../../../core/services/logger_services.dart';
import '../../../category/category.dart';
import '../../domain/domain.dart';
import '../models/expense_model.dart';

class ExpenseFirebaseRepository implements ExpenseRepository {
  static const collectionPath = 'expenses';
  final FirebaseFirestore firestore;
  final CategoryRepository categoryRepository;
  ExpenseFirebaseRepository({
    required this.categoryRepository,
    required this.firestore,
  });

  @override
  Future<void> createExpense(ExpenseModel expense) async {
    try {
      await firestore
          .collection(collectionPath)
          .doc(expense.id)
          .set(expense.toJson());
    } on FirebaseException catch (e) {
      final exception = AppExceptionUtils.handleFirebaseError(e);
      LoggerService.error('deleteExpense', exception.message);
      throw exception;
    } catch (e, s) {
      LoggerService.error('createExpense', e, s);
      rethrow;
    }
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    try {
      await firestore.collection(collectionPath).doc(expenseId).delete();
    } on FirebaseException catch (e) {
      final exception = AppExceptionUtils.handleFirebaseError(e);
      LoggerService.error('deleteExpense', exception.message);
      throw exception;
    } catch (e, s) {
      LoggerService.error('deleteExpense', e, s);
      rethrow;
    }
  }

  @override
  Future<List<ExpenseEntity>> getExpenses({required String categoryId}) {
    try {
      final result = firestore
          .collection(collectionPath)
          .where('categoryId', isEqualTo: categoryId)
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs.map<ExpenseEntity>(
          (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return ExpenseModel.fromJson(doc.data()).toEntity();
          },
        ).toList();
      });
      return result;
    } on FirebaseException catch (e) {
      final exception = AppExceptionUtils.handleFirebaseError(e);
      LoggerService.error('deleteExpense', exception.message);
      throw exception;
    } catch (e, s) {
      LoggerService.error('incrementValuePaymentMethod', e, s);
      rethrow;
    }
  }

  @override
  Future<List<ExpenseEntity>> getExpensesByPeriodCreated({
    required String categoryId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Cria uma referência inicial para a coleção
      var query = firestore
          .collection(collectionPath)
          .where('categoryId', isEqualTo: categoryId);

      // Adiciona o filtro de startDate se ele não for nulo
      if (startDate != null) {
        query = query.where('created', isGreaterThanOrEqualTo: startDate);
      }

      // Adiciona o filtro de endDate
      if (endDate != null) {
        query = query.where('created', isLessThanOrEqualTo: endDate);
      }

      // Converte os documentos para a entidade de despesa
      final result = query.get().then(
        (value) {
          return value.docs.map(
            (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
              return ExpenseModel.fromJson(doc.data()).toEntity();
            },
          ).toList();
        },
      );

      return result;
    } on FirebaseException catch (e) {
      final exception = AppExceptionUtils.handleFirebaseError(e);
      LoggerService.error('deleteExpense', exception.message);
      throw exception;
    } catch (e, s) {
      LoggerService.error('incrementValuePaymentMethod', e, s);
      rethrow;
    }
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    try {
      await firestore
          .collection(collectionPath)
          .doc(expense.id)
          .update(expense.toJson());
    } on FirebaseException catch (e) {
      final exception = AppExceptionUtils.handleFirebaseError(e);
      LoggerService.error('deleteExpense', exception.message);
      throw exception;
    } catch (e, s) {
      LoggerService.error('incrementValuePaymentMethod', e, s);
      rethrow;
    }
  }

  @override
  Future<double> getExpensesSumByPeriodCreated({
    required String categoryId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final result = await getExpensesByPeriodCreated(
        categoryId: categoryId,
        endDate: endDate,
        startDate: startDate,
      ).then(
        (values) {
          return values.fold<double>(
            0.0,
            (total, expense) => total + expense.value,
          );
        },
      );
      return result;
    } on FirebaseException catch (e) {
      final exception = AppExceptionUtils.handleFirebaseError(e);
      LoggerService.error('deleteExpense', exception.message);
      throw exception;
    } catch (e, s) {
      LoggerService.error('incrementValuePaymentMethod', e, s);
      rethrow;
    }
  }

  @override
  Future<PaginatedResult<ExpenseEntity>> getExpensesPaginated({
    required String categoryId,
    DateTime? startDate,
    DateTime? endDate,
    required PaginationParams paginationParams,
  }) async {
    try {
      // Build base query with ordering (REQUIRED for cursor pagination)
      Query<Map<String, dynamic>> query = firestore
          .collection(collectionPath)
          .where('categoryId', isEqualTo: categoryId)
          .orderBy('created', descending: true);

      // Apply date filters
      if (startDate != null) {
        query = query.where(
          'created',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        );
      }
      if (endDate != null) {
        query = query.where(
          'created',
          isLessThanOrEqualTo: Timestamp.fromDate(endDate),
        );
      }

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
          .map((doc) => ExpenseModel.fromJson(doc.data()).toEntity())
          .toList();

      // Get last document for cursor
      final lastDocument = actualDocs.isNotEmpty ? actualDocs.last : null;

      return PaginatedResult<ExpenseEntity>(
        items: items,
        lastDocument: lastDocument,
        hasMore: hasMore,
      );
    } on FirebaseException catch (e) {
      final exception = AppExceptionUtils.handleFirebaseError(e);
      LoggerService.error('getExpensesPaginated', exception.message);
      throw exception;
    } catch (e, s) {
      LoggerService.error('getExpensesPaginated', e, s);
      rethrow;
    }
  }
}
