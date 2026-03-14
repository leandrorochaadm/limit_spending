# Naming Conventions

> Referência completa de nomenclatura. Carregar sob demanda via `@.claude/rules/naming.md`.

## Regra fundamental

**Todo código, nomes de classes, variáveis, métodos, arquivos e constantes DEVEM ser em inglês.**
Comentários e documentação podem ser em português.

---

## Arquivos (snake_case)

| Tipo | Padrão | Exemplo |
|---|---|---|
| Entity | `{entity}_entity.dart` | `bidding_entity.dart` |
| Model | `{entity}_model.dart` | `bidding_model.dart` |
| Repository (contrato) | `{entity}_repository.dart` | `bidding_repository.dart` |
| Repository (impl) | `{entity}_repository_impl.dart` | `bidding_repository_impl.dart` |
| UseCase | `{action}_{entity}_use_case.dart` | `analyze_bidding_use_case.dart` |
| DataSource (abstrato) | `{entity}_remote_data_source.dart` | `bidding_remote_data_source.dart` |
| DataSource (impl) | `{entity}_remote_data_source_impl.dart` | `bidding_remote_data_source_impl.dart` |
| Service (abstrato) | `{entity}_service.dart` | `bidding_service.dart` |
| Service (impl) | `{entity}_service_impl.dart` | `bidding_service_impl.dart` |
| Enum | `{entity}_status_enum.dart` | `bidding_status_enum.dart` |
| Provider | `{feature}_provider.dart` | `bidding_analysis_provider.dart` |
| State | `{feature}_state.dart` | `bidding_analysis_state.dart` |
| Screen | `{feature}_screen.dart` | `bidding_analysis_screen.dart` |
| Widget | `{description}_widget.dart` | `bidding_card_widget.dart` |
| Failures (feature) | `{feature}_failures.dart` | `bidding_failures.dart` |

---

## Classes (PascalCase + sufixo obrigatório)

| Tipo | Sufixo | Exemplo |
|---|---|---|
| Entity | `Entity` | `BiddingEntity` |
| Model | `Model` | `BiddingModel` |
| Repository contrato | `Repository` | `BiddingRepository` |
| Repository impl | `RepositoryImpl` | `BiddingRepositoryImpl` |
| UseCase | `UseCase` | `AnalyzeBiddingUseCase` |
| UseCase Params | `Params` | `AnalyzeBiddingParams` |
| DataSource abstrato | `RemoteDataSource` / `LocalDataSource` | `BiddingRemoteDataSource` |
| DataSource impl | `RemoteDataSourceImpl` | `BiddingRemoteDataSourceImpl` |
| Service abstrato | `Service` | `BiddingService` |
| Service impl | `ServiceImpl` | `BiddingServiceImpl` |
| Enum | `Enum` | `BiddingStatusEnum` |
| Notifier | `Notifier` | `BiddingAnalysisNotifier` |
| State (base) | `State` | `BiddingAnalysisState` |
| Screen | `Screen` | `BiddingAnalysisScreen` |
| Widget | `Widget` | `BiddingCardWidget` |
| Failure | `Failure` | `InvalidBiddingFailure` |

---

## Providers (camelCase + sufixo `Provider`)

| Tipo | Padrão | Exemplo |
|---|---|---|
| DataSource | `{feature}RemoteDataSourceProvider` | `biddingRemoteDataSourceProvider` |
| Repository | `{feature}RepositoryProvider` | `biddingRepositoryProvider` |
| UseCase | `{action}{Feature}UseCaseProvider` | `analyzeBiddingUseCaseProvider` |
| StateNotifier | `{feature}Provider` | `biddingAnalysisProvider` |
| AsyncNotifier | `{feature}ListProvider` | `biddingListProvider` |
| Family | `{feature}ByIdProvider` | `patientByIdProvider` |
| Computed/bool | `is{Condition}Provider` | `isDoctorProvider` |
| Core/global | nome descritivo | `apiClientProvider`, `networkInfoProvider` |

---

## Failures (PascalCase + sufixo `Failure`)

| Categoria | Exemplo |
|---|---|
| Negócio (feature) | `InvalidBiddingFailure`, `ExpiredBiddingFailure`, `ValueAboveCeilingFailure` |
| Infra (core) | `ServerFailure`, `NetworkFailure`, `TimeoutFailure`, `CacheFailure` |
| Auth (core) | `UnauthorizedFailure`, `AuthFailure`, `ForbiddenFailure` |

---

## UseCases — verbo no infinitivo + sufixo `UseCase`

```
AnalyzeBiddingUseCase       # Analisar edital
GetAllBiddingsUseCase       # Buscar todos
GetBiddingByIdUseCase       # Buscar por ID
CreateProposalUseCase       # Criar proposta
DeleteBiddingUseCase        # Deletar
ValidateDocumentUseCase     # Validar documento
TokenizeCardUseCase         # Tokenizar cartão
```

---

## Regra geral: sufixo deixa o papel imediatamente claro

```dart
// ❌ Ambíguo — é Entity? Model? UseCase? Service?
class Bidding { ... }
class AnalyzeBidding { ... }
class BiddingStatus { ... }

// ✅ Claro — papel arquitetural visível no nome
class BiddingEntity { ... }
class AnalyzeBiddingUseCase { ... }
class BiddingStatusEnum { ... }
```
