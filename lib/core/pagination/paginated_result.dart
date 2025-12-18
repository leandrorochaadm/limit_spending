import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Generic class to hold paginated results with cursor information.
/// The cursor is the last DocumentSnapshot used for Firestore pagination.
class PaginatedResult<T> extends Equatable {
  final List<T> items;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  const PaginatedResult({
    required this.items,
    this.lastDocument,
    this.hasMore = true,
  });

  /// Factory for empty result
  factory PaginatedResult.empty() => const PaginatedResult(
        items: [],
        lastDocument: null,
        hasMore: false,
      );

  /// Merge with new page results
  PaginatedResult<T> merge(PaginatedResult<T> nextPage) {
    return PaginatedResult<T>(
      items: [...items, ...nextPage.items],
      lastDocument: nextPage.lastDocument,
      hasMore: nextPage.hasMore,
    );
  }

  @override
  List<Object?> get props => [items, lastDocument, hasMore];
}
