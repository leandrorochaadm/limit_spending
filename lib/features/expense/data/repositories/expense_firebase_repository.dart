import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/domain.dart';
import '../models/expense_model.dart';

class ExpenseFirebaseRepository implements ExpenseRepository {
  static const collectionPath = 'expenses';
  final FirebaseFirestore firestore;
  ExpenseFirebaseRepository({required this.firestore});

  @override
  Future<void> createExpense(ExpenseModel expense) async => await firestore
      .collection(collectionPath)
      .doc(expense.id)
      .set(expense.toJson());

  @override
  Future<void> deleteExpense(ExpenseModel expense) async =>
      await firestore.collection(collectionPath).doc(expense.id).delete();

  @override
  Stream<List<ExpenseEntity>> getExpenses() {
    return firestore.collection(collectionPath).snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs.map(
          (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return ExpenseModel.fromJson(doc.data()).toEntity();
          },
        ).toList();
      },
    );
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async => await firestore
      .collection(collectionPath)
      .doc(expense.id)
      .update(expense.toJson());
}
