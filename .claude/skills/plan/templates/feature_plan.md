# Template: Plano de Feature

Use esta estrutura ao criar planos para novas funcionalidades.

---

```markdown
# Plano de Implementação: [Nome da Feature]

**Data:** [YYYY-MM-DD]
**Tipo:** Feature
**Complexidade:** [Baixa | Média | Alta]
**Feature module:** `features/[feature_name]/`

---

## 1. Objetivo

[Descrição clara do que será implementado e por quê. 2-3 frases.]

### Resultado esperado
- [O que o usuário final verá/poderá fazer]
- [Comportamento esperado]

---

## 2. Análise do Contexto Atual

### Estado atual
[O que existe hoje no codebase relacionado a esta feature]

### Dependências existentes
| Componente | Caminho | Relação |
|------------|---------|---------|
| [Ex: AuthRepository] | `lib/features/auth/domain/repositories/` | [Será reutilizado] |

### Componentes reutilizáveis de `lib/core/`
| Componente | Caminho | Uso |
|------------|---------|-----|
| [Ex: ClyvoButton] | `lib/core/ui/buttons/` | [Botão de ação principal] |

---

## 3. Arquitetura da Solução

### Diagrama de camadas
```
Presentation (Screen/Widgets)
    ↓ usa
Provider (StateNotifier + State)
    ↓ chama
Domain (UseCase)
    ↓ usa
Domain (Repository interface)
    ↓ implementa
Data (RepositoryImpl → DataSource)
    ↓ chama
Data (RemoteDataSource → ApiClient)
```

### Fluxo de dados
[Descreva o fluxo: usuário interage → provider → usecase → repository → datasource → API]

---

## 4. Arquivos a Criar

### Data Layer
| # | Arquivo | Descrição | Complexidade |
|---|---------|-----------|--------------|
| 1 | `features/[feature]/data/datasources/[feature]_remote_data_source.dart` | Interface + Impl do datasource | [Baixa/Média/Alta] |
| 2 | `features/[feature]/data/models/[model]_model.dart` | Model com fromJson/toJson | [Baixa/Média/Alta] |
| 3 | `features/[feature]/data/repositories/[feature]_repository_impl.dart` | Implementação do repository | [Baixa/Média/Alta] |

### Domain Layer
| # | Arquivo | Descrição | Complexidade |
|---|---------|-----------|--------------|
| 4 | `features/[feature]/domain/entities/[entity]_entity.dart` | Entity com Equatable | [Baixa/Média/Alta] |
| 5 | `features/[feature]/domain/repositories/[feature]_repository.dart` | Interface do repository | [Baixa/Média/Alta] |
| 6 | `features/[feature]/domain/usecases/[action]_use_case.dart` | UseCase com Either | [Baixa/Média/Alta] |

### Presentation Layer
| # | Arquivo | Descrição | Complexidade |
|---|---------|-----------|--------------|
| 7 | `features/[feature]/presentation/providers/[feature]_state.dart` | Sealed classes de estado | [Baixa/Média/Alta] |
| 8 | `features/[feature]/presentation/providers/[feature]_provider.dart` | StateNotifier + Provider | [Baixa/Média/Alta] |
| 9 | `features/[feature]/presentation/screens/[screen]_screen.dart` | Tela principal | [Baixa/Média/Alta] |
| 10 | `features/[feature]/presentation/widgets/[widget]_widget.dart` | Widgets específicos | [Baixa/Média/Alta] |

---

## 5. Arquivos a Modificar

| # | Arquivo | Modificação | Impacto |
|---|---------|-------------|---------|
| 1 | `lib/core/router/app_router.dart` | Adicionar rota para nova tela | Baixo |

---

## 6. Endpoints da API

| Método | Endpoint | Request Body | Response | Status |
|--------|----------|-------------|----------|--------|
| GET | `/api/v1/medical/[endpoint]` | - | `{ "data": [...] }` | [Existe/A criar] |

---

## 7. Modelos de Dados

### [EntityName]Entity
```dart
// Campos da entity
class [Name]Entity extends Equatable {
  final String id;
  final String name;
  // ...
}
```

### [ModelName]Model
```dart
// Campos do model (estende entity)
@JsonSerializable()
class [Name]Model extends [Name]Entity {
  // fromJson, toJson
}
```

---

## 8. Ordem de Implementação

Siga esta ordem para evitar erros de compilação:

| Passo | Arquivo | Depende de | Ação |
|-------|---------|------------|------|
| 1 | Entity | - | Criar entity com campos e Equatable |
| 2 | Model | Entity | Criar model estendendo entity |
| 3 | Repository (interface) | Entity | Definir contrato do repository |
| 4 | DataSource | Model | Criar interface + impl com ApiClient |
| 5 | Repository (impl) | DataSource, Repository | Implementar repository |
| 6 | UseCase | Repository | Criar usecase com Either |
| 7 | State | Entity | Criar sealed classes de estado |
| 8 | Provider | UseCase, State | Criar StateNotifier |
| 9 | Screen | Provider | Criar tela consumindo provider |
| 10 | Router | Screen | Adicionar rota |

---

## 9. Riscos e Mitigações

| Risco | Impacto | Probabilidade | Mitigação |
|-------|---------|---------------|-----------|
| [Ex: API não pronta] | Alto | Média | [Usar mock data temporário] |

---

## 10. Checklist de Validação

- [ ] Todos os arquivos seguem a nomenclatura do projeto
- [ ] Entities estendem `Equatable` com `copyWith()` e `empty()`
- [ ] Models estendem suas respectivas Entities
- [ ] Repository retorna `Either<Failure, T>`
- [ ] DataSource verifica rede com `AppUtils.hasNetworkConnection()`
- [ ] UseCase estende `UseCase<T, Params>`
- [ ] States usam sealed classes em arquivo separado
- [ ] Provider definido no final do arquivo do repository/usecase
- [ ] Imports relativos (não `package:clyvo_mobile/`)
- [ ] Componentes de `lib/core/ui/` reutilizados quando possível
- [ ] Rota adicionada em `app_router.dart`
- [ ] `dart run build_runner build` executado após criar models
- [ ] Linhas com máximo 120 caracteres
```
