import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/exceptions/app_exception_utils.dart';
import '../../../../core/pagination/pagination.dart';
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
      await firestore.collection(collectionPath).doc(category.id).set(category.toModel().toJson());
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
      await firestore.collection(collectionPath).doc(category.id).update(category.toModel().toJson());
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
      final doc = await firestore.collection(collectionPath).doc(categoryId).get();
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
      await firestore.collection(collectionPath).doc(categoryId).update({'consumed': consumed});
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
      await firestore.collection(collectionPath).doc(categoryId).update({'consumed': FieldValue.increment(consumed)});
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
      final resutl = await firestore.collection(collectionPath).doc(categoryId).get().then(
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

  @override
  Future<PaginatedResult<CategoryEntity>> getCategoriesPaginated({
    required PaginationParams paginationParams,
  }) async {
    try {
      // Build base query with ordering (REQUIRED for cursor pagination)
      Query<Map<String, dynamic>> query =
          firestore.collection(collectionPath).orderBy('name');

      // Apply cursor pagination
      if (paginationParams.startAfterDocument != null) {
        query = query.startAfterDocument(paginationParams.startAfterDocument!);
      }

      // Apply limit (fetch one extra to check if there are more)
      query = query.limit(paginationParams.pageSize + 1);

      // Execute query
      final snapshot = await query.get();
      final docs = snapshot.docs;

      // Check if there are more results
      final hasMore = docs.length > paginationParams.pageSize;

      // Get actual items (remove extra if present)
      final actualDocs =
          hasMore ? docs.sublist(0, paginationParams.pageSize) : docs;

      // Map to entities
      final items = actualDocs
          .map((doc) => CategoryModel.fromJson(doc.data()).toEntity())
          .toList();

      // Get last document for cursor
      final lastDocument = actualDocs.isNotEmpty ? actualDocs.last : null;

      return PaginatedResult<CategoryEntity>(
        items: items,
        lastDocument: lastDocument,
        hasMore: hasMore,
      );
    } on FirebaseException catch (e) {
      final exception = AppExceptionUtils.handleFirebaseError(e);
      LoggerService.error('getCategoriesPaginated', exception.message);
      throw exception;
    } catch (e, s) {
      LoggerService.error('getCategoriesPaginated', e, s);
      rethrow;
    }
  }
}
