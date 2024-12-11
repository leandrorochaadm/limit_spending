import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/exceptions/app_exception_utils.dart';
import '../../../core/services/logger_services.dart';
import '../domain/entities/debt_entity.dart';
import '../domain/repositoy.dart';
import 'debts_model.dart';

class FirebaseDebtRepository implements DebtRepository {
  final FirebaseFirestore firestore;
  static const collectionPath = 'debt';

  FirebaseDebtRepository(this.firestore);

  @override
  Future<void> addDebtValue(String debtId, double debtValue) async {
    try {
      await firestore
          .collection(collectionPath)
          .doc(debtId)
          .update({'value': FieldValue.increment(debtValue)});
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
  Future<List<DebtEntity>> getDebts() {
    try {
      final result = firestore.collection(collectionPath).get().then(
        (QuerySnapshot<Map<String, dynamic>> snapshot) {
          return snapshot.docs.map(
            (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
              return DebtModel.fromJson(doc.data()).toEntity();
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
      LoggerService.error('createExpense', e, s);
      rethrow;
    }
  }

  @override
  Future<double> getSumDebts() async {
    try {
      final result = await firestore.collection(collectionPath).get().then(
        (QuerySnapshot<Map<String, dynamic>> snapshot) {
          return snapshot.docs.fold<double>(
            0.0,
            (previousValue, doc) =>
                previousValue + (doc.data()['value'] as num).toDouble(),
          );
        },
      );
      return result;
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
  Future<void> createDebt(DebtEntity debt) async {
    try {
      await firestore
          .collection(collectionPath)
          .doc(debt.id)
          .set(debt.toModel().toJson());
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
  Future<void> deleteDebt(String debtId) async {
    try {
      await firestore.collection(collectionPath).doc(debtId).delete();
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
  Future<void> updateDebt(DebtEntity debt) async {
    try {
      await firestore
          .collection(collectionPath)
          .doc(debt.id)
          .update(debt.toModel().toJson());
    } on FirebaseException catch (e) {
      final exception = AppExceptionUtils.handleFirebaseError(e);
      LoggerService.error('deleteExpense', exception.message);
      throw exception;
    } catch (e, s) {
      LoggerService.error('createExpense', e, s);
      rethrow;
    }
  }
}
