import 'package:cloud_firestore/cloud_firestore.dart';

import 'category_model.dart';

class Controller {
  Controller({required this.firestore});

  final FirebaseFirestore firestore;

  Stream<List<Category>> readCategories() {
    return firestore.collection('categories').snapshots().map(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                Category.fromJson(doc.data()))
            .toList();
      },
    );
  }

  void createCategory(Category category) {
    firestore.collection('categories').doc(category.id).set(category.toJson());
  }

  void updateCategory(Category category) {
    firestore
        .collection('categories')
        .doc(category.id)
        .update(category.toJson());
  }

  void deleteCategory(String categoryId) {
    firestore.collection('categories').doc(categoryId).delete();
  }
}
