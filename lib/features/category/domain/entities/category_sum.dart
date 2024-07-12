class CategorySumEntity {
  final double consumed;
  final double limit;
  final double balance;
  CategorySumEntity({
    required this.consumed,
    required this.limit,
    required this.balance,
  });
  @override
  String toString() {
    return 'CategorySumEntity(consumed: $consumed, limit: $limit)';
  }
}
