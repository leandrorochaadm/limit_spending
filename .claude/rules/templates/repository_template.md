---
paths:
  - "lib/features/*/data/repositories/**"
---

# Repository Template

## Implementation

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/logging/logger_provider.dart';
import '../../../../core/mixins/exception_handler_mixin.dart';
import '../../domain/entities/{feature}_entity.dart';
import '../../domain/repositories/{feature}_repository.dart';
import '../datasources/{feature}_remote_data_source.dart';

class {Feature}RepositoryImpl
    with LoggerMixin, ExceptionHandlerMixin
    implements {Feature}Repository {
  final {Feature}RemoteDataSource _dataSource;

  {Feature}RepositoryImpl({required {Feature}RemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Either<Failure, {Feature}Entity>> get{Feature}ById(String id) async {
    try {
      final model = await _dataSource.get{Feature}ById(id);
      return Right(model.toEntity());
    } catch (e, stackTrace) {
      return handleException(e, stackTrace);
    }
  }

  @override
  Future<Either<Failure, List<{Feature}Entity>>> get{Feature}s() async {
    try {
      final models = await _dataSource.get{Feature}s();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e, stackTrace) {
      return handleException(e, stackTrace);
    }
  }

  @override
  Future<Either<Failure, void>> delete{Feature}(String id) async {
    try {
      await _dataSource.delete{Feature}(id);
      return const Right(null);
    } catch (e, stackTrace) {
      return handleException(e, stackTrace);
    }
  }
}

/// Provider
final {feature}RepositoryProvider = Provider<{Feature}Repository>((ref) {
  return {Feature}RepositoryImpl(
    dataSource: ref.watch({feature}RemoteDataSourceProvider),
  );
});
```

## Mixin Order (CRITICAL)
1. `LoggerMixin` FIRST
2. `ExceptionHandlerMixin` SECOND (uses `on LoggerMixin`)

## Rules
- Return Entity types only (never Model)
- Convert Model -> Entity via `model.toEntity()`
- Use `handleException(e, stackTrace)` for all catch blocks
- Define Provider at the end of the file
