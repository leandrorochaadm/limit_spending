import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/exceptions/exceptions.dart';
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
}
