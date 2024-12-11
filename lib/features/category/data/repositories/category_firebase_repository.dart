import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/exceptions/app_exception_utils.dart';
import '../../../../core/services/logger_services.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/category_repository.dart';
import '../models/category_model.dart';

class CategoryFirebaseRepository implements CategoryRepository {
  static const collectionPath = 'categories';
  final FirebaseFirestore firestore;
  CategoryFirebaseRepository(this.firestore);

  @override
  Future<void> createCategory(CategoryEntity category) async {
    try {
      await firestore
          .collection(collectionPath)
          .doc(category.id)
          .set(category.toModel().toJson());
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
  Future<void> deleteCategory(String categoryId) async {
    try {
      await firestore.collection(collectionPath).doc(categoryId).delete();
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
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final result = await firestore.collection(collectionPath).get().then(
        (QuerySnapshot<Map<String, dynamic>> snapshot) {
          return snapshot.docs.map(
            (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
              return CategoryModel.fromJson(doc.data()).toEntity();
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
  Future<void> updateCategory(CategoryEntity category) async {
    try {
      await firestore
          .collection(collectionPath)
          .doc(category.id)
          .update(category.toModel().toJson());
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
  Future<CategoryEntity> categoryById(String categoryId) async {
    try {
      final doc =
          await firestore.collection(collectionPath).doc(categoryId).get();
      if (doc.exists) {
        return CategoryModel.fromJson(doc.data()!).toEntity();
      } else {
        throw Exception('Categoria não encontrada');
      }
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
  Future<void> updateCategoryConsumed(
    String categoryId,
    double consumed,
  ) async {
    try {
      await firestore
          .collection(collectionPath)
          .doc(categoryId)
          .update({'consumed': consumed});
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
  Future<void> addConsumedCategory(String categoryId, double consumed) async {
    try {
      await firestore
          .collection(collectionPath)
          .doc(categoryId)
          .update({'consumed': FieldValue.increment(consumed)});
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
  Future<CategoryEntity> getCategoryStream(String categoryId) async {
    try {
      final resutl =
          await firestore.collection(collectionPath).doc(categoryId).get().then(
        (snapshot) {
          if (snapshot.exists) {
            final data = snapshot.data();
            return CategoryModel.fromJson(data!).toEntity();
          } else {
            throw Exception('Categoria não encontrada');
          }
        },
      );
      return resutl;
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
