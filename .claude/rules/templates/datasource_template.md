---
paths:
  - "lib/features/*/data/datasources/**"
---

# DataSource Template

## Abstract Class

```dart
abstract class {Feature}RemoteDataSource {
  Future<{Feature}Model> get{Feature}ById(String id);
  Future<List<{Feature}Model>> get{Feature}s();
  Future<{Feature}Model> create{Feature}({Feature}Model model);
  Future<{Feature}Model> update{Feature}(String id, {Feature}Model model);
  Future<void> delete{Feature}(String id);
}
```

## Implementation

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/logging/logger_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/{feature}_model.dart';

class {Feature}RemoteDataSourceImpl with LoggerMixin implements {Feature}RemoteDataSource {
  final ApiClient _apiClient;

  {Feature}RemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<{Feature}Model> get{Feature}ById(String id) async {
    try {
      final response = await _apiClient.get(
        '${AppConstants.{feature}sEndpoint}/$id',
      );
      return {Feature}Model.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      rethrow; // ApiClient already converts DioException to custom exceptions
    }
  }

  @override
  Future<List<{Feature}Model>> get{Feature}s() async {
    try {
      final response = await _apiClient.get(AppConstants.{feature}sEndpoint);
      final list = response as List<dynamic>;
      return list
          .map((item) => {Feature}Model.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<{Feature}Model> create{Feature}({Feature}Model model) async {
    try {
      final response = await _apiClient.post(
        AppConstants.{feature}sEndpoint,
        data: model.toJson(),
      );
      return {Feature}Model.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> delete{Feature}(String id) async {
    try {
      await _apiClient.delete('${AppConstants.{feature}sEndpoint}/$id');
    } catch (e) {
      rethrow;
    }
  }
}

/// Provider
final {feature}RemoteDataSourceProvider = Provider<{Feature}RemoteDataSource>((ref) {
  return {Feature}RemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});
```
