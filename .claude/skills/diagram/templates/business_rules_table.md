# Template: Tabela de Regras de Negócio

> O artefato mais importante. Preencha antes de qualquer diagrama.
> Cada linha é uma decisão arquitetural: a regra vai para Entity ou UseCase?

---

## Quando usar

- **SEMPRE** — preencha antes de criar qualquer arquivo de código
- Antes de definir Entities (identifica getters de regra)
- Antes de criar UseCases (identifica lógica de fluxo)
- Como referência durante code review

## Regra de decisão

| Tipo | Onde fica | Critério |
|------|-----------|----------|
| **Intrínseca** | `Entity` | Regra que depende APENAS dos dados do próprio objeto |
| **Fluxo** | `UseCase` | Regra que depende de outros objetos, repositórios ou contexto externo |

## Formato de saída

```markdown
## Tabela de Regras de Negócio — [FeatureName]

| Regra | Tipo | Onde fica | Retorno | Observação |
|-------|------|-----------|---------|------------|
| [Entidade] está ativa? | Intrínseca | `[Entity]Entity` | `bool` | Getter `isActive` |
| [Entidade] tem [campo]? | Intrínseca | `[Entity]Entity` | `bool` | Getter `has[Campo]` |
| Total de [itens] | Intrínseca | `[Entity]Entity` | `double` | Getter `total[Campo]` |
| [Valor] excede o limite? | Intrínseca | `[Entity]Entity` | `bool` | Getter `exceeds[Limite]` |
| [Ator] pode [ação]? | Fluxo | `[Action]UseCase` | `Either` | Depende de [outro repositório] |
| [Documento/dado] está válido? | Fluxo | `[Validate]UseCase` | `Either` | Depende de serviço externo |
| Classificar [entidade] por [critério] | Fluxo | `[Classify]UseCase` | `Either` | Combina dados de múltiplos repos |
| [Buscar/Criar/Atualizar/Deletar] [entidade] | Fluxo | `[Action]UseCase` | `Either` | CRUD básico |

### Failures mapeadas

| Failure | Quando ocorre | Dados que carrega |
|---------|---------------|-------------------|
| `[Invalid]Failure` | [Condição que gera o erro] | `[campo: tipo]` |
| `[NotFound]Failure` | [Condição que gera o erro] | `[id: String]` |
| `[Expired]Failure` | [Condição que gera o erro] | `[expiredAt: DateTime]` |
```

## Exemplo preenchido (feature: consultation)

```markdown
## Tabela de Regras de Negócio — Consultation

| Regra | Tipo | Onde fica | Retorno | Observação |
|-------|------|-----------|---------|------------|
| Consulta está ativa? | Intrínseca | `ConsultationEntity` | `bool` | `isActive` — status == scheduled ou in_progress |
| Consulta pode ser cancelada? | Intrínseca | `ConsultationEntity` | `bool` | `isCancellable` — isActive && !isPast |
| Consulta está no passado? | Intrínseca | `ConsultationEntity` | `bool` | `isPast` — scheduledAt.isBefore(now) |
| Duração estimada em minutos | Intrínseca | `ConsultationEntity` | `int` | `durationInMinutes` |
| Paciente pode agendar? | Fluxo | `CreateConsultationUseCase` | `Either` | Depende de PatientRepository |
| Médico tem disponibilidade? | Fluxo | `CreateConsultationUseCase` | `Either` | Depende de DoctorRepository |
| Buscar consulta por ID | Fluxo | `GetConsultationByIdUseCase` | `Either` | CRUD |
| Cancelar consulta | Fluxo | `CancelConsultationUseCase` | `Either` | Valida `isCancellable` antes |

### Failures mapeadas

| Failure | Quando ocorre | Dados que carrega |
|---------|---------------|-------------------|
| `ConsultationNotFoundFailure` | ID não existe no backend | `id: String` |
| `ConsultationAlreadyCancelledFailure` | Tentativa de cancelar já cancelada | `consultationId: String` |
| `DoctorUnavailableFailure` | Médico sem horário disponível | `doctorId: String, requestedAt: DateTime` |
```
