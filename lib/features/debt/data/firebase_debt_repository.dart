import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/entity.dart';
import '../domain/repositoy.dart';
import 'debts_model.dart';

class FirebaseDebtRepository implements DebtRepository {
  final FirebaseFirestore firestore;
  static const collectionPath = 'debt';

  FirebaseDebtRepository(this.firestore);

  @override
  Future<void> addDebtValue(String debtId, double debtValue) async {
    await firestore
        .collection(collectionPath)
        .doc(debtId)
        .update({'value': FieldValue.increment(debtValue)});
  }

  @override
  Stream<List<DebtEntity>> getDebts() {
    return firestore.collection(collectionPath).snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs.map(
          (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return DebtModel.fromJson(doc.data()).toEntity();
          },
        ).toList();
      },
    );
  }

  @override
  Stream<double> getSumDebts() {
    return firestore.collection(collectionPath).snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs.fold<double>(
          0.0,
          (previousValue, doc) =>
              previousValue + (doc.data()['value'] as num).toDouble(),
        );
      },
    );
  }

  @override
  Future<void> createDebt(DebtEntity debt) async {
    await firestore
        .collection(collectionPath)
        .doc(debt.id)
        .set(debt.toModel().toJson());
  }

  @override
  Future<void> deleteDebt(String debtId) {
    return firestore.collection(collectionPath).doc(debtId).delete();
  }

  @override
  Future<void> updateDebt(DebtEntity debt) {
    return firestore
        .collection(collectionPath)
        .doc(debt.id)
        .update(debt.toModel().toJson());
  }
}
