---
name: documentation
description: Especialista em documentação de código Flutter/Dart seguindo padrões do projeto
argument-hint: [filepath ou diretório]
allowed-tools: Read, Grep, Glob, Edit
---

# Skill: Documentação de Código Flutter/Dart

Especialista em documentação de código Flutter/Dart seguindo Effective Dart e padrões do projeto Clyvo Mobile.

## Missão

1. **Aplicar regras de documentação** seguindo Effective Dart
2. **Garantir consistência** com o estilo do projeto
3. **Seguir Clean Architecture** na estruturação da documentação
4. **Português do Brasil** para documentação, inglês para nomes de código

---

## Princípios do Effective Dart

- **Use `///` doc comments** — nunca `/** */` ou `/* */`
- **Primeira frase = sumário completo** — deve fazer sentido isoladamente
- **Separe o sumário** — linha em branco após a primeira frase
- **Frases completas** — maiúscula no início, ponto final no fim
- **80 caracteres por linha** em comentários
- **Brevidade** — seja breve mas completo

---

## Hierarquia de Documentação

| Prioridade | O quê | Obrigatório? |
|------------|-------|--------------|
| 1 | Classes, métodos, propriedades **públicas** | Sim |
| 2 | APIs de biblioteca (library-level) | Recomendado |
| 3 | APIs internas com lógica não óbvia | Opcional |
| 4 | Código privado complexo | Conforme necessário |

**Evite documentar:** código auto-explicativo, overrides simples, getters/setters triviais.

---

## Padrões de Verbos

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| Funções/Métodos | Terceira pessoa | `/// Calcula o saldo disponível.` |
| Propriedades | Frases nominais | `/// O saldo atual da carteira.` |
| Booleanos | "Whether" | `/// Whether o usuário está autenticado.` |
| Classes | Frases nominais | `/// Um datasource para gerenciar operações de saque.` |
| Enums | Propósito | `/// Status possíveis de uma solicitação.` |

---

## Estrutura de Doc Comment

```dart
/// [SUMÁRIO EM UMA FRASE].
///
/// [Descrição detalhada em parágrafos subsequentes.]
///
/// [Parâmetros, retorno, exceções em prosa.]
///
/// [Exemplos de uso, se relevante.]
```

---

## Referências com Colchetes

```dart
/// Carrega os dados do [User] a partir do [userId] fornecido.
///
/// Retorna um [Either] contendo [Failure] ou [User].
///
/// Veja também:
/// * [SessionHelper] para gerenciar sessões
```

---

## Comentários Inline (//)

- **Use para:** lógica complexa, regras de negócio, workarounds
- **Evite para:** código auto-explicativo
- **TODOs:** `// TODO(username): Descrição da tarefa`
- **FIXMEs:** `// FIXME: Descrição do problema`

---

## Logging

- **Nunca use `print()`** — use `ConsoleLogger` de `@lib/core/logging/`
- **Sempre nomeie seus logs** com tag
- **Inclua contexto** relevante na mensagem

---

## Annotations

| Annotation | Uso |
|------------|-----|
| `@Deprecated('Use X instead')` | Código obsoleto com alternativa |
| `@visibleForTesting` | Métodos internos expostos para teste |
| `@protected` | Métodos para subclasses apenas |

---

## Regras Críticas

1. **Documente o "porquê"**, não o "o quê"
2. **Português do Brasil** para docs, inglês para código
3. **Colchetes `[]`** para referenciar identificadores Dart
4. **Exemplos de uso** para APIs complexas
5. **Liste possíveis Failures** em métodos que retornam Either
6. **Nunca `print()`** — use `ConsoleLogger`

---

## Templates Disponíveis

Use `Read` para carregar o template necessário:

| Template | Arquivo | Quando Usar |
|----------|---------|-------------|
| Regras Dart Doc | `@.claude/skills/documentation/templates/dart_doc_rules.md` | Regras gerais e formatação |
| DataSource | `@.claude/skills/documentation/templates/datasource_doc.md` | Documentar DataSources |
| Repository | `@.claude/skills/documentation/templates/repository_doc.md` | Documentar Repositories |
| UseCase | `@.claude/skills/documentation/templates/usecase_doc.md` | Documentar UseCases |
| Entity | `@.claude/skills/documentation/templates/entity_doc.md` | Documentar Entities |
| Model | `@.claude/skills/documentation/templates/model_doc.md` | Documentar Models |
| Provider | `@.claude/skills/documentation/templates/provider_doc.md` | Documentar StateNotifiers |
| Widget | `@.claude/skills/documentation/templates/widget_doc.md` | Documentar Widgets/Screens |
| Boas Práticas | `@.claude/skills/documentation/templates/best_practices.md` | Checklist e annotations |

**Instrução**: Ao documentar código, leia o template correspondente à camada do componente.

---

## Checklist Rápido

- [ ] Toda classe pública tem doc comment com sumário
- [ ] Métodos públicos documentados com propósito
- [ ] Possíveis Failures listadas em métodos Either
- [ ] Identificadores referenciados com `[]`
- [ ] Primeira frase faz sentido isoladamente
- [ ] Sem `print()` — usando `ConsoleLogger`
- [ ] TODOs no formato `// TODO(username): descrição`
