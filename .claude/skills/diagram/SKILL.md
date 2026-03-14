---
name: diagram
description: Gera diagramas Mermaid para mapear regras de negócio antes de codar. Se a feature existe, analisa o código real. Se for nova, gera templates com placeholders. Cria Casos de Uso, Fluxo, Entidade, Estados, Sequência e Tabela de Regras. Salva em temp/diagrams/.
argument-hint: [nome_da_feature]
allowed-tools: Read, Write, Glob
---

# Skill: Diagramas de Regras de Negócio

Gera diagramas Mermaid para mapear regras de negócio de uma feature **antes de codar**.

Funciona em **modo híbrido**:
- **Feature existente** → lê o código real e gera diagramas preenchidos com dados reais
- **Feature nova** → gera templates com placeholders descritivos para preencher antes de codar

---

## Fluxo de Execução

### 1. Identificar a Feature

Se o argumento foi fornecido, use como nome da feature.
Se **não foi fornecido**, pergunte ao usuário:

```
Qual o nome da feature que vamos mapear? (ex: consultation, payment, auth)
```

Use o nome em snake_case para o arquivo e em PascalCase nos diagramas.

### 2. Detectar o Modo (Híbrido)

Use `Glob` para verificar se a feature existe:

```
lib/features/{feature_name}/
```

#### Modo A — Feature existente

Leia os arquivos relevantes **em paralelo** usando `Read`:

| Arquivo(s) | O que extrair |
|------------|---------------|
| `domain/entities/*.dart` | Campos, getters bool/computed (regras intrínsecas) |
| `domain/usecases/*.dart` | Nomes, Params, lógica de fluxo, Failures usadas |
| `domain/repositories/*.dart` | Métodos do contrato (para o diagrama de Sequência) |
| `data/datasources/*.dart` | Métodos do DataSource (para o diagrama de Sequência) |
| `presentation/providers/*_state.dart` | Estados sealed class existentes |

Com os dados lidos, **preencha os diagramas com informações reais** — nomes de classes, campos, métodos, estados e failures como estão no código.

> Se algum arquivo ainda não existir dentro de uma feature existente (ex: estado ainda não criado), use placeholders para aquela seção específica.

#### Modo B — Feature nova

Não há código para ler. Gere todos os diagramas com **placeholders descritivos**. Não deixe campos vazios — use:

| Placeholder | Exemplo real |
|-------------|-------------|
| `[Ator principal]` | `Médico`, `Paciente` |
| `[Ação do UseCase]` | `Criar Consulta`, `Cancelar Agendamento` |
| `[EntidadeEntity]` | `ConsultationEntity` |
| `[campo: Tipo]` | `status: ConsultationStatusEnum` |
| `[isRegra]: bool` | `isActive: bool` |
| `[Estado]` | `Loading`, `Success`, `Error` |
| `[XxxFailure]` | `ConsultationNotFoundFailure` |

### 3. Carregar os Templates

Use `Read` para carregar todos os templates **em paralelo**:

```
.claude/skills/diagram/templates/business_rules_table.md
.claude/skills/diagram/templates/use_case_diagram.md
.claude/skills/diagram/templates/flowchart_diagram.md
.claude/skills/diagram/templates/entity_diagram.md
.claude/skills/diagram/templates/states_diagram.md
.claude/skills/diagram/templates/sequence_diagram.md
```

### 4. Montar o Arquivo Final

Gere um único arquivo `.md` com os 6 diagramas + checklist nesta ordem:

1. **Tabela de Regras de Negócio** — o mapa: Entity vs UseCase
2. **Casos de Uso** — o que o sistema faz (mapeia `domain/usecases/`)
3. **Fluxo (Flowchart)** — decisões dentro de cada UseCase
4. **Entidade (Classes)** — Entities e suas regras intrínsecas
5. **Estados** — transições de estado da tela (sealed class)
6. **Sequência** — ordem das chamadas entre camadas (valida arquitetura)
7. **Checklist de Consistência** — valida se os diagramas estão alinhados entre si
8. **Catálogo de Failures** — classifica quais Failures já existem no core vs. precisam ser criadas

### 5. Salvar o Arquivo

Salve em `temp/diagrams/` com o formato:
```
temp/diagrams/{feature_name}_diagrams.md
```

Se a pasta `temp/diagrams/` não existir, crie-a.

---

---

## Checklist de Consistência (seção 7 do arquivo gerado)

Após gerar os 6 diagramas, gere uma seção `## Checklist de Consistência` no arquivo de saída.

O checklist cruza as informações entre os diagramas e marca cada item como `✅` (ok) ou `⚠️` (atenção — requer revisão).

### Regras de validação cruzada

| Verificação | Como validar | Flag se |
|-------------|-------------|---------|
| UseCases completos | Todo UseCase do diagrama de Casos de Uso tem um fluxo no Flowchart? | Algum UC sem fluxo → `⚠️` |
| Failures cobertas | Toda Failure da Tabela de Regras aparece em algum bloco `Left` do Fluxo ou Sequência? | Failure órfã → `⚠️` |
| Estados suficientes | Existe estado `Loading`, pelo menos um `Success` e pelo menos um `Error`? | Faltando algum → `⚠️` |
| Transições de erro | Todo `Left(Failure)` no Fluxo tem uma transição correspondente no diagrama de Estados? | Failure sem estado de erro → `⚠️` |
| Entities no diagrama | Toda Entity da Tabela de Regras aparece no diagrama de Entidade? | Entity ausente → `⚠️` |
| Regras intrínsecas | Todo getter `bool`/`double` da Tabela de Regras aparece nos métodos da Entity no diagrama de Entidade? | Getter ausente → `⚠️` |
| Sequência completa | O diagrama de Sequência cobre o caminho feliz E pelo menos um caminho de erro? | Sem `alt/else` → `⚠️` |
| Regra de dependência | No diagrama de Sequência, UI nunca chama Repository ou DataSource diretamente? | Violação → `⚠️` |

### Formato da seção no arquivo gerado

```markdown
## Checklist de Consistência

> Cruza os diagramas acima para detectar inconsistências antes de codar.
> ✅ = ok | ⚠️ = requer atenção

### Cobertura de UseCases
- [✅/⚠️] `[UseCaseName]` — tem fluxo no Flowchart? [Sim/Não]
- [✅/⚠️] `[UseCaseName]` — aparece na Sequência? [Sim/Não]

### Cobertura de Failures
- [✅/⚠️] `[XxxFailure]` — aparece no Fluxo? [Sim/Não]
- [✅/⚠️] `[XxxFailure]` — tem estado de erro correspondente? [Sim/Não]

### Completude dos Estados
- [✅/⚠️] Estado `Loading` definido?
- [✅/⚠️] Estado `Success` com dados definido?
- [✅/⚠️] Estado `Error` com mensagem definido?
- [✅/⚠️] Todo `Left(Failure)` tem transição de estado?

### Completude das Entities
- [✅/⚠️] `[EntityName]` — aparece no diagrama de Entidade?
- [✅/⚠️] Getter `[isRegra]` — aparece nos métodos da Entity?

### Regra de Dependência (Sequência)
- [✅/⚠️] UI → Notifier → UseCase → Repository → DataSource (ordem correta)?
- [✅/⚠️] Diagrama de Sequência tem bloco `alt/else` para erros?

### Resumo
**[N] itens ok** | **[N] itens requerem atenção**

[Se houver ⚠️:]
#### Itens para revisar antes de codar
- [ ] [descrição do item que requer atenção]
```

> **Importante:** Para features novas com placeholders, o checklist marcará muitos itens como `⚠️` — isso é esperado. O objetivo é guiar o preenchimento.

---

## Catálogo de Failures (seção 8 do arquivo gerado)

Após o checklist, gere uma seção `## Catálogo de Failures` no arquivo de saída.

### Como gerar

1. **Colete** todas as Failures mencionadas nos diagramas (Tabela de Regras, Fluxo, Sequência)
2. **Compare** com as Failures que já existem em `lib/core/error/failures.dart`:

| Failure do core | Quando reutilizar |
|-----------------|------------------|
| `NetworkFailure` | Sem conexão com a internet |
| `ServerFailure` | Erro HTTP 5xx genérico |
| `TimeoutFailure` | Timeout de requisição |
| `CacheFailure` | Erro de leitura/escrita em cache local |
| `ValidationFailure` | Dados inválidos na entrada |
| `AuthFailure` | Falha genérica de autenticação |
| `UnauthorizedFailure` | HTTP 401 — não autenticado |
| `ForbiddenFailure` | HTTP 403 — sem permissão |
| `NotFoundFailure` | HTTP 404 — recurso não encontrado (genérico) |
| `InputFailure` | Input inválido do usuário |
| `RequestCancelledFailure` | Requisição cancelada |
| `AudioFailure` | Apenas para voice_assistant |

3. **Classifique** cada Failure encontrada nos diagramas:
   - `✅ Reutilizar` — já existe no core, use direto
   - `🆕 Criar` — específica da feature, criar em `features/{feature}/domain/{feature}_failures.dart`

### Formato da seção no arquivo gerado

```markdown
## Catálogo de Failures

| Failure | Status | Onde usar / Criar |
|---------|--------|-------------------|
| `NetworkFailure` | ✅ Reutilizar | `lib/core/error/failures.dart` |
| `ServerFailure` | ✅ Reutilizar | `lib/core/error/failures.dart` |
| `[XxxNotFound]Failure` | 🆕 Criar | `features/{feature}/domain/{feature}_failures.dart` |
| `[YyyInvalid]Failure` | 🆕 Criar | `features/{feature}/domain/{feature}_failures.dart` |

### Failures a criar: `features/{feature}/domain/{feature}_failures.dart`

\`\`\`dart
// Failures específicas da feature {feature}
sealed class [Xxx]Failure extends Failure {
  const [Xxx]Failure({required super.message, super.statusCode});
}

final class [XxxNotFound]Failure extends [Xxx]Failure {
  final String [id];
  const [XxxNotFound]Failure({required this.[id]})
      : super(message: ''); // mensagem definida no _mapFailure do Notifier
}
```

> **Regra:** Failure carrega **dados**, não mensagem de texto para UI.
> A mensagem é responsabilidade do `_mapFailure` no Notifier.
```

---

## Regras Críticas

1. **Modo híbrido é obrigatório** — SEMPRE verifique se a feature existe antes de gerar
2. **Feature existente = dados reais** — nunca gere placeholders onde há código real para ler
3. **NUNCA gere diagramas vazios** — dados reais ou placeholders descritivos
4. **NUNCA altere arquivos em `lib/`** — esta skill é somente leitura
5. **Mermaid válido** — verifique a sintaxe mentalmente antes de escrever
6. **Diagramas pequenos são melhores** — foque no essencial, não no exaustivo
7. **Tabela de Regras é o artefato mais importante** — preencha-a primeiro

---

## Formato de Apresentação

Após salvar o arquivo, apresente ao usuário:

```
## Diagramas gerados

**Feature:** {feature_name}
**Modo:** [Análise de código real | Template para nova feature]
**Arquivo:** temp/diagrams/{feature_name}_diagrams.md

### O que foi gerado
- Tabela de Regras — [N] regras mapeadas ([N] intrínsecas, [N] de fluxo)
- Casos de Uso — [N] casos de uso, [N] atores
- Fluxo — [N] decisões, [N] Failures mapeadas
- Entidade — [N] entidades, [N] regras intrínsecas
- Estados — [N] estados, [N] transições
- Sequência — [N] participantes, [N] caminhos (sucesso + erros)

### Próximos passos
[Se feature existente:]
  Revise os diagramas — eles refletem o código atual. Use como base para planejar melhorias.
[Se feature nova:]
  Preencha os placeholders em `temp/diagrams/{feature_name}_diagrams.md` antes de implementar.
  Depois rode `/plan {feature_name}` para gerar o plano de implementação.
```

---

## Templates Disponíveis

| Template | Arquivo | Mapeia para |
|----------|---------|-------------|
| Tabela de Regras | `templates/business_rules_table.md` | Entity vs UseCase |
| Casos de Uso | `templates/use_case_diagram.md` | `domain/usecases/` |
| Fluxo | `templates/flowchart_diagram.md` | Lógica interna do UseCase |
| Entidade | `templates/entity_diagram.md` | `domain/entities/` |
| Estados | `templates/states_diagram.md` | `presentation/providers/*_state.dart` |
| Sequência | `templates/sequence_diagram.md` | Fluxo completo entre camadas |
