class CategorySumEntity {
  final double consumed;
  final double limit;
  CategorySumEntity({required this.consumed, required this.limit});
  @override
  String toString() {
    return 'CategorySumEntity(consumed: $consumed, limit: $limit)';
  }
}
