import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../models/category_model.dart';

class CategoryFirebaseRepository implements CategoryRepository {
  final FirebaseFirestore firestore;
  CategoryFirebaseRepository(this.firestore);

  @override
  Future<void> createCategory(CategoryEntity category) async {
    await firestore
        .collection('categories')
        .doc(category.id)
        .set(category.toModel().toJson());
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    await firestore.collection('categories').doc(categoryId).delete();
  }

  @override
  Stream<List<CategoryEntity>> getCategories() {
    return firestore.collection('categories').snapshots().map(
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
        .collection('categories')
        .doc(category.id)
        .update(category.toModel().toJson());
  }
}