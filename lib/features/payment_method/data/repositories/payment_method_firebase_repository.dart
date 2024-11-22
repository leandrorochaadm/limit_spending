import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/payment_method_entity.dart';
import '../../domain/repositories/payment_method_repository.dart';
import '../models/payment_method_model.dart';

class PaymentMethodFirebaseRepository implements PaymentMethodRepository {
  static const collectionPath = 'paymentMethods';
  final FirebaseFirestore firestore;

  PaymentMethodFirebaseRepository(this.firestore);
  @override
  Future<void> createPaymentMethod(PaymentMethodEntity paymentMethod) async {
    await firestore
        .collection(collectionPath)
        .doc(paymentMethod.id)
        .set(paymentMethod.toModel().toJson());
  }

  @override
  Future<void> deletePaymentMethod(PaymentMethodEntity paymentMethod) async {
    await firestore.collection(collectionPath).doc(paymentMethod.id).delete();
  }

  @override
  Future<List<PaymentMethodEntity>> getPaymentMethods() {
    return firestore.collection(collectionPath).get().then(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs.map(
          (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return PaymentMethodModel.fromJson(doc.data()).toEntity();
          },
        ).toList();
      },
    );
  }

  @override
  Future<void> incrementValuePaymentMethod(
    String paymentMethodId,
    double value,
  ) async {
    await firestore
        .collection(collectionPath)
        .doc(paymentMethodId)
        .update({'value': FieldValue.increment(value)});
  }

  @override
  Future<void> updatePaymentMethod(PaymentMethodEntity paymentMethod) async {
    await firestore
        .collection(collectionPath)
        .doc(paymentMethod.id)
        .update(paymentMethod.toModel().toJson());
  }
}
