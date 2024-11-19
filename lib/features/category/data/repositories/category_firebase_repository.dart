import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/entities.dart';
import '../../domain/repositories/category_repository.dart';
import '../models/category_model.dart';

class CategoryFirebaseRepository implements CategoryRepository {
  static const collectionPath = 'categories';
  final FirebaseFirestore firestore;
  CategoryFirebaseRepository(this.firestore);

  @override
  Future<void> createCategory(CategoryEntity category) async {
    await firestore
        .collection(collectionPath)
        .doc(category.id)
        .set(category.toModel().toJson());
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    await firestore.collection(collectionPath).doc(categoryId).delete();
  }

  @override
  Future<List<CategoryEntity>> getCategories() {
    return firestore.collection(collectionPath).get().then(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs.map(
          (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return CategoryModel.fromJson(doc.data()).toEntity();
          },
        ).toList();
      },
    );
  }

  @override
  Future<void> updateCategory(CategoryEntity category) async {
    await firestore
        .collection(collectionPath)
        .doc(category.id)
        .update(category.toModel().toJson());
  }

  @override
  Future<CategoryEntity> categoryById(String categoryId) async {
    final doc =
        await firestore.collection(collectionPath).doc(categoryId).get();
    if (doc.exists) {
      return CategoryModel.fromJson(doc.data()!).toEntity();
    } else {
      throw Exception('Categoria não encontrada');
    }
  }

  Future<void> updateCategoryConsumed(
    String categoryId,
    double consumed,
  ) async {
    await firestore
        .collection(collectionPath)
        .doc(categoryId)
        .update({'consumed': consumed});
  }

  @override
  Future<void> addConsumedCategory(String categoryId, double consumed) async {
    await firestore
        .collection(collectionPath)
        .doc(categoryId)
        .update({'consumed': FieldValue.increment(consumed)});
  }

  @override
  Future<CategoryEntity> getCategoryStream(String categoryId) {
    return firestore.collection(collectionPath).doc(categoryId).get().then(
      (snapshot) {
        if (snapshot.exists) {
          final data = snapshot.data();
          return CategoryModel.fromJson(data!).toEntity();
        } else {
          throw Exception('Categoria não encontrada');
        }
      },
    );
  }
}
