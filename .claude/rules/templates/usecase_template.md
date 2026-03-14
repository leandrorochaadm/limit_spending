---
paths:
  - "lib/features/*/domain/usecases/**"
---

# UseCase Template

Nome obrigatório: **verbo + substantivo + sufixo `UseCase`**
Ex: `GetPatientByIdUseCase`, `AnalyzeBiddingUseCase`, `CreateProposalUseCase`

## Com Parâmetros

```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/{feature}_entity.dart';
import '../repositories/{feature}_repository.dart';

class Get{Feature}ByIdUseCase
    implements UseCase<{Feature}Entity, Get{Feature}ByIdParams> {
  final {Feature}Repository _repository;

  Get{Feature}ByIdUseCase(this._repository);

  @override
  Future<Either<Failure, {Feature}Entity>> call(
    Get{Feature}ByIdParams params,
  ) async {
    return await _repository.get{Feature}ById(params.id);
  }
}

class Get{Feature}ByIdParams extends Equatable {
  final String id;

  const Get{Feature}ByIdParams({required this.id});

  @override
  List<Object> get props => [id];
}
```

## Sem Parâmetros

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/{feature}_entity.dart';
import '../repositories/{feature}_repository.dart';

class GetAll{Feature}sUseCase
    implements UseCase<List<{Feature}Entity>, NoParams> {
  final {Feature}Repository _repository;

  GetAll{Feature}sUseCase(this._repository);

  @override
  Future<Either<Failure, List<{Feature}Entity>>> call(NoParams params) async {
    return await _repository.getAll{Feature}s();
  }
}
```

## Com orquestração (múltiplos repositories/services)

```dart
class Analyze{Feature}UseCase
    implements UseCase<AnalysisResult, Analyze{Feature}Params> {
  final {Feature}Repository _repository;
  final ClassifierService _classifier;

  Analyze{Feature}UseCase(this._repository, this._classifier);

  @override
  Future<Either<Failure, AnalysisResult>> call(
    Analyze{Feature}Params params,
  ) async {
    final result = await _repository.extract(params.path);

    return result.fold(
      (failure) => Left(failure),
      (entity) {
        if (!entity.isValid) return Left(InvalidDataFailure());
        final classification = _classifier.classify(entity);
        return Right(AnalysisResult(entity: entity, classification: classification));
      },
    );
  }
}
```

## Rules
- MUST implement `UseCase<T, Params>` from `@lib/core/usecases/usecase.dart`
- MUST implement `call()` (NOT `execute()`)
- MUST have suffix `UseCase` in class name
- Use `NoParams` when no parameters needed
- Params class MUST extend `Equatable`
- NUNCA contém mensagens de texto para UI — retorna `Failure` com dados
- Provider definido no final do arquivo
