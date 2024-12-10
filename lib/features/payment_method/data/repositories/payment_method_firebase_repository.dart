import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/exceptions/app_exception_utils.dart';
import '../../../../core/services/logger_services.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/repositories/payment_method_repository.dart';
import '../models/payment_method_model.dart';

class PaymentMethodFirebaseRepository implements PaymentMethodRepository {
  static const collectionPath = 'paymentMethods';
  final FirebaseFirestore firestore;

  PaymentMethodFirebaseRepository(this.firestore);
  @override
  Future<void> createPaymentMethod(PaymentMethodEntity paymentMethod) async {
    try {
      await firestore
          .collection(collectionPath)
          .doc(paymentMethod.id)
          .set(paymentMethod.toModel().toJson());
    } on FirebaseException catch (e) {
      throw AppExceptionUtils.handleFirebaseError(e);
    } catch (e, s) {
      LoggerService.error('incrementValuePaymentMethod', e, s);
      rethrow;
    }
  }

  @override
  Future<void> deletePaymentMethod(PaymentMethodEntity paymentMethod) async {
    try {
      await firestore.collection(collectionPath).doc(paymentMethod.id).delete();
    } on FirebaseException catch (e) {
      throw AppExceptionUtils.handleFirebaseError(e);
    } catch (e, s) {
      LoggerService.error('incrementValuePaymentMethod', e, s);
      rethrow;
    }
  }

  @override
  Future<List<PaymentMethodEntity>> getPaymentMethods() async {
    try {
      final result = await firestore.collection(collectionPath).get().then(
        (QuerySnapshot<Map<String, dynamic>> snapshot) {
          return snapshot.docs.map(
            (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
              return PaymentMethodModel.fromJson(doc.data()).toEntity();
            },
          ).toList();
        },
      );
      return result;
    } on FirebaseException catch (e) {
      throw AppExceptionUtils.handleFirebaseError(e);
    } catch (e, s) {
      LoggerService.error('incrementValuePaymentMethod', e, s);
      rethrow;
    }
  }

  @override
  Future<PaymentMethodEntity?> getPaymentById(String id) async {
    try {
      final resultFirebase =
          await firestore.collection(collectionPath).doc(id).get();
      if (resultFirebase.data() != null) {
        final resultEntity =
            PaymentMethodModel.fromJson(resultFirebase.data()!).toEntity();
        return resultEntity;
      }
      return null;
    } on FirebaseException catch (e) {
      throw AppExceptionUtils.handleFirebaseError(e);
    } catch (e, s) {
      LoggerService.error('getPaymentById', e, s);
      rethrow;
    }
  }

  @override
  Future<void> incrementValuePaymentMethod(
    String paymentMethodId,
    double value,
  ) async {
    try {
      await firestore
          .collection(collectionPath)
          .doc(paymentMethodId)
          .update({'value': FieldValue.increment(value)});
    } on FirebaseException catch (e) {
      throw AppExceptionUtils.handleFirebaseError(e);
    } catch (e, s) {
      LoggerService.error('incrementValuePaymentMethod', e, s);
      rethrow;
    }
  }

  @override
  Future<void> updatePaymentMethod(PaymentMethodEntity paymentMethod) async {
    try {
      await firestore
          .collection(collectionPath)
          .doc(paymentMethod.id)
          .update(paymentMethod.toModel().toJson());
    } on FirebaseException catch (e) {
      throw AppExceptionUtils.handleFirebaseError(e);
    } catch (e, s) {
      LoggerService.error('incrementValuePaymentMethod', e, s);
      rethrow;
    }
  }
}
