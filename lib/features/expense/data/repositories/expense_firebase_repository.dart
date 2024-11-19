import 'package:cloud_firestore/cloud_firestore.dart';

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
    await firestore
        .collection(collectionPath)
        .doc(expense.id)
        .set(expense.toJson());

    if (expense.categoryId.isNotEmpty) {
      await categoryRepository.addConsumedCategory(
        expense.categoryId,
        expense.value,
      );
    }
  }

  @override
  Future<void> deleteExpense(ExpenseModel expense) async {
    await firestore.collection(collectionPath).doc(expense.id).delete();
    if (expense.categoryId.isNotEmpty) {
      await categoryRepository.addConsumedCategory(
        expense.categoryId,
        -expense.value,
      );
    }
  }

  @override
  Future<List<ExpenseEntity>> getExpenses({required String categoryId}) {
    return firestore
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
  }

  @override
  Future<List<ExpenseEntity>> getExpensesByPeriodCreated({
    required String categoryId,
    DateTime? startDate,
    required DateTime endDate,
  }) {
    // Cria uma referência inicial para a coleção
    var query = firestore
        .collection(collectionPath)
        .where('categoryId', isEqualTo: categoryId);

    // Adiciona o filtro de startDate se ele não for nulo
    if (startDate != null) {
      query = query.where('createdDate', isGreaterThanOrEqualTo: startDate);
    }

    // Adiciona o filtro de endDate
    query = query.where('createdDate', isLessThanOrEqualTo: endDate);

    // Converte os documentos para a entidade de despesa
    return query.get().then(
      (value) {
        return value.docs.map(
          (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return ExpenseModel.fromJson(doc.data()).toEntity();
          },
        ).toList();
      },
    );
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await firestore
        .collection(collectionPath)
        .doc(expense.id)
        .update(expense.toJson());
  }
}
