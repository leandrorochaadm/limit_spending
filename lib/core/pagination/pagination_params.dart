import 'package:cloud_firestore/cloud_firestore.dart';

/// Parameters for paginated queries.
class PaginationParams {
  final int pageSize;
  final DocumentSnapshot? startAfterDocument;

  const PaginationParams({
    this.pageSize = 10,
    this.startAfterDocument,
  });

  /// First page request
  factory PaginationParams.firstPage({int pageSize = 10}) => PaginationParams(
        pageSize: pageSize,
        startAfterDocument: null,
      );

  /// Next page request using cursor
  factory PaginationParams.nextPage({
    required DocumentSnapshot lastDocument,
    int pageSize = 10,
  }) =>
      PaginationParams(
        pageSize: pageSize,
        startAfterDocument: lastDocument,
      );

  bool get isFirstPage => startAfterDocument == null;
}
