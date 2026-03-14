# Template: Diagrama de Sequência

> Mostra **a ordem das chamadas entre camadas**.
> Valida que a regra de dependência da Clean Architecture está sendo respeitada.

---

## Quando usar

- Para validar o fluxo completo de um UseCase antes de codar
- Para identificar quem chama quem (e detectar violações de arquitetura)
- Para documentar o caminho feliz E os caminhos de erro

## Dicas de preenchimento

- **Participantes** = as camadas: UI, Notifier, UseCase, Repository, DataSource
- **`->>` síncrono** = chamada direta (sem `await`)
- **`-->>` resposta** = retorno (pontilhado)
- **`->>+` ativa** = inicia processamento (caixa de ativação)
- **`->>-` desativa** = conclui processamento
- **`alt/else`** = caminhos alternativos (Right vs Left do Either)
- **`Note`** = anotações sobre regras ou conversões importantes

## Regra de dependência (validar no diagrama)

```
UI → Notifier → UseCase → Repository (contrato) → RepositoryImpl → DataSource
```

Se o diagrama mostrar UI chamando DataSource diretamente = violação arquitetural.

## Formato de saída

````markdown
## Diagrama de Sequência — [UseCaseName]

```mermaid
sequenceDiagram
  autonumber
  actor User as 👤 Usuário
  participant UI as Screen
  participant N as Notifier
  participant UC as [Action]UseCase
  participant R as [Entity]Repository
  participant DS as [Entity]DataSource

  User->>UI: [ação do usuário]
  UI->>+N: [método do notifier]()
  N->>N: emit([Feature]Loading)

  N->>+UC: call([Params])
  UC->>+R: [method]([params])
  R->>+DS: [method]([params])
  DS-->>-R: [Model]
  Note right of R: converte Model → Entity
  R-->>-UC: Either<Failure, [Entity]>

  alt Right — sucesso
    UC-->>N: Right([Entity])
    Note right of N: fold → emit Success
    N->>-N: emit([Feature]Success([entity]))
    N-->>UI: rebuilda com novo estado
    UI-->>User: exibe [resultado]
  else Left — falha
    UC-->>N: Left([XxxFailure])
    Note right of N: _mapFailure → mensagem
    N->>N: emit([Feature]Error(message))
    N-->>UI: rebuilda com estado de erro
    UI-->>User: exibe mensagem de erro
  end
```

### Notas arquiteturais

| Ponto | Observação |
|-------|-----------|
| Model → Entity | Acontece no Repository (`model.toEntity()`) — NUNCA no UseCase ou UI |
| Failure → message | Acontece no Notifier (`_mapFailure`) — NUNCA no UseCase |
| Either | Morre no Notifier — State recebe dado já resolvido |
| `ref.watch` vs `ref.read` | UI usa `watch` no build, `read` em callbacks |
````

## Exemplo preenchido (feature: consultation → GetConsultationByIdUseCase)

````markdown
## Diagrama de Sequência — GetConsultationByIdUseCase

```mermaid
sequenceDiagram
  autonumber
  actor User as 👤 Paciente
  participant UI as ConsultationScreen
  participant N as ConsultationNotifier
  participant UC as GetConsultationByIdUseCase
  participant R as ConsultationRepository
  participant DS as ConsultationDataSource

  User->>UI: abre tela (initState)
  UI->>+N: loadConsultation(id)
  N->>N: emit(ConsultationLoading)

  N->>+UC: call(GetConsultationParams(id))
  UC->>+R: getById(id)
  R->>+DS: fetchConsultation(id)
  DS-->>-R: ConsultationModel (JSON)
  Note right of R: model.toEntity()
  R-->>-UC: Either<Failure, ConsultationEntity>

  alt Right — consulta encontrada
    UC-->>N: Right(ConsultationEntity)
    Note right of N: fold → emit Success
    N->>-N: emit(ConsultationSuccess(consultation))
    N-->>UI: rebuilda
    UI-->>User: exibe detalhes da consulta
  else Left(ConsultationNotFoundFailure)
    UC-->>N: Left(ConsultationNotFoundFailure)
    Note right of N: _mapFailure → "Consulta não encontrada"
    N->>N: emit(ConsultationError("Consulta não encontrada"))
    N-->>UI: rebuilda com erro
    UI-->>User: exibe tela de erro com retry
  else Left(NetworkFailure)
    UC-->>N: Left(NetworkFailure)
    Note right of N: _mapFailure → "Sem conexão"
    N->>N: emit(ConsultationError("Sem conexão com a internet"))
    N-->>UI: rebuilda com erro
    UI-->>User: exibe tela de erro com retry
  end
```

### Notas arquiteturais

| Ponto | Observação |
|-------|-----------|
| Model → Entity | `ConsultationModel.toEntity()` no `ConsultationRepositoryImpl` |
| Failure → message | `_mapFailure` no `ConsultationNotifier` |
| Either | Morre no `fold` do Notifier — `ConsultationSuccess` recebe `ConsultationEntity` puro |
| Múltiplos Left | Cada `Failure` tem mensagem diferente mapeada no `_mapFailure` |
````
