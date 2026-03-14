# Architecture - Clean Architecture Layer Rules

## Dependency Rule (INVIOLÁVEL)

```
Presentation → depende de → Domain
Data         → depende de → Domain
Domain       → NÃO DEPENDE DE NADA
```

- A camada `domain/` NUNCA importa nada de `data/` ou `presentation/`
- A camada `domain/` NUNCA importa pacotes externos (json_annotation, dio, hive, etc.)
- Apenas Dart puro na camada `domain/`

## Data Flow

```
UI (input do usuário)
    ↓ dispara método no Notifier
Notifier / Provider
    ↓ monta Params, chama UseCase
UseCase (Params)
    ↓ chama Repository com Entity ou tipos simples
Repository Contract (Domain)
    ↓ implementação na camada Data
Repository Impl (Data)
    ↓ chama DataSource com Model
DataSource
    ↓ converte para/de JSON
API / Banco
```

## Layer Type Rules

| Camada | Usa | Recebe | Retorna | Pode Importar |
|--------|-----|--------|---------|---------------|
| Presentation | Entity | Entity | Entity | Domain |
| Domain | Entity | Entity | Entity | Nada |
| Repository | Ambos* | Model | Entity | Domain |
| DataSource | Model | JSON/Map | Model | Nada |

*Repositories recebem Model internamente, convertem para Entity antes de retornar

## Error Handling por Camada

| Camada | Tipo de erro que trata | Como trata |
|--------|------------------------|------------|
| Entity | Regras intrínsecas ao objeto | Getters booleanos, validações |
| UseCase | Regras de fluxo + transforma erros de infra em domínio | Retorna Left(Failure) |
| Repository | Erros de I/O (rede, banco, parse) | try/catch → Left(Failure) |
| Notifier | Nenhum. Traduz Failure → State | fold → State de erro |
| UI | Exibe estado | switch exaustivo |

## Critical Rules
- Presentation: ONLY Entity, NEVER Model or Map
- Domain: ONLY Entity, NEVER Model or Map
- Repositories: Convert Model -> Entity before returning (`model.toEntity()`)
- DataSources: ONLY Model, with fromJson/toJson
- Model NUNCA herda de Entity — são classes separadas
- Entity NUNCA importa json_annotation, dio, ou qualquer pacote externo

## Anti-Patterns (NUNCA fazer)

| Anti-pattern | Por quê é errado |
|---|---|
| `class BiddingModel extends BiddingEntity` | Acopla Domain com Data — violação da regra de dependência |
| `@JsonSerializable()` na Entity | Entity não pode conhecer serialização — responsabilidade do Model |
| `copyWith()` na Entity | Entity é imutável — construir novo objeto explicitamente |
| `final List<X> items;` sem unmodifiable | `final` protege referência, não conteúdo — qualquer um pode fazer `items.add(...)` |
| Regra de negócio no Notifier/Provider | Pertence ao UseCase ou Entity |
| `Either` no State | Either morre no Notifier — State só recebe dado já resolvido |
| Notifier chamando DataSource diretamente | Pula UseCase e Repository — viola a cadeia de dependências |
| Mensagem de texto na Failure | Failure carrega dados, não strings para UI |
| Import cruzado entre features | Se precisar comunicar features, usar `core/` ou contrato compartilhado |
| Classe sem sufixo arquitetural | `Bidding` não diz se é Entity, Model, UseCase — sufixo torna o papel imediatamente claro |
| `ref.read()` no `build()` | UI nunca atualiza — usar `ref.watch()` no build |

## Checklist de Criação de Feature

### Implementação (nessa ordem)

1. **Domain primeiro**
   - [ ] Entity em `domain/entities/` (sufixo `Entity`, sem `copyWith`, collections unmodifiable)
   - [ ] Failures específicas (sealed, Equatable, dados não mensagens)
   - [ ] Contrato do Repository em `domain/repositories/`
   - [ ] Params do UseCase
   - [ ] UseCase em `domain/usecases/` (sufixo `UseCase`)

2. **Data**
   - [ ] Model em `data/models/` com `toEntity()` e `fromEntity()` — NUNCA extends Entity
   - [ ] `dart run build_runner build --build-filter="lib/features/**/data/models/**"`
   - [ ] DataSource (remote/local) em `data/datasources/`
   - [ ] Repository Impl em `data/repositories/` (com LoggerMixin, ExceptionHandlerMixin)

3. **Presentation**
   - [ ] States com `sealed class extends Equatable`, `props => [hashCode]` na base
   - [ ] Notifier com `_mapFailure()` switch em `presentation/providers/`
   - [ ] Page com `switch` exaustivo em `presentation/screens/`
   - [ ] Widgets reutilizáveis em `presentation/widgets/`

4. **Validação**
   - [ ] Entity não importa nada externo
   - [ ] Entity não tem `copyWith`
   - [ ] Coleções da Entity são unmodifiable
   - [ ] Model não extends Entity
   - [ ] UseCase não tem mensagem de texto
   - [ ] Notifier não tem regra de negócio
   - [ ] Failures carregam dados, não mensagens
   - [ ] Todas as classes têm sufixo arquitetural

## Referência Rápida

| O que preciso fazer? | Onde fica? |
|---|---|
| Validar se objeto está válido | Entity (getter bool) |
| Calcular valor total dos itens | Entity (getter) |
| Buscar dados na API | DataSource → Repository |
| Verificar se usuário pode fazer X | UseCase |
| Combinar dados de múltiplos repositories | UseCase |
| Converter Failure em mensagem | Notifier (`_mapFailure`) |
| Formatar valor como moeda | UI (formatter) |
| Formatar data | UI (formatter) |
| Serializar/desserializar JSON | Model (json_serializable) |
