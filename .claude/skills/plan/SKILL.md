---
name: plan
description: Gera planos detalhados de implementação, refatoração, correção de bugs, migração ou decisão arquitetural. Salva o plano como .md na pasta temp/.
argument-hint: [descrição da tarefa]
allowed-tools: Read, Grep, Glob, Write
---

# Skill: Plano Detalhado

Gera planos de implementação completos e detalhados, salvando o resultado em `temp/`.

## Fluxo de Execução

### 1. Identificar o Tipo de Plano

Com base na descrição fornecida pelo usuário, identifique o tipo de plano mais adequado:

| Tipo | Quando Usar | Template |
|------|-------------|----------|
| **Feature** | Nova funcionalidade ou feature completa | `feature_plan.md` |
| **Refactor** | Refatoração de código existente | `refactor_plan.md` |
| **Bugfix** | Correção de bugs ou problemas | `bugfix_plan.md` |
| **Migration** | Migração de tecnologia, API, padrão | `migration_plan.md` |
| **Architecture** | Decisão técnica com trade-offs | `architecture_plan.md` |

**Se o tipo não for óbvio**, pergunte ao usuário qual tipo se aplica melhor.

### 2. Analisar o Contexto

Antes de gerar o plano, **OBRIGATORIAMENTE** faça uma análise do codebase:

1. **Identifique a feature/módulo** envolvido usando `Glob` e `Grep`
2. **Leia os arquivos relevantes** com `Read` para entender o estado atual
3. **Mapeie dependências** entre os arquivos afetados
4. **Verifique padrões existentes** na mesma feature e em features similares
5. **Consulte `core-reference.md`** para verificar componentes reutilizáveis

### 3. Carregar Template

Use `Read` para carregar o template correspondente:
```
@.claude/skills/plan/templates/[tipo]_plan.md
```

### 4. Gerar o Plano

Preencha o template com informações reais do codebase. **Não use placeholders genéricos** - todos os caminhos de arquivo, nomes de classes e referências devem ser concretos.

### 5. Salvar o Arquivo

Salve o plano na pasta `temp/` com o formato:
```
temp/plano-[tema]-[YYYY-MM-DD].md
```

Onde:
- `[tema]` = nome curto e descritivo em kebab-case (ex: `auth-refactor`, `payment-feature`, `api-migration`)
- `[YYYY-MM-DD]` = data atual

## Regras Críticas

1. **SEMPRE analise o codebase antes de gerar o plano** - nunca gere planos genéricos
2. **Use caminhos reais** de arquivos que existem ou que serão criados
3. **Respeite a Clean Architecture** do projeto (data/domain/presentation)
4. **Verifique componentes existentes** em `lib/core/ui/` antes de propor novos widgets
5. **Inclua todos os arquivos afetados** - não omita nenhum
6. **Estime complexidade** de cada passo (baixa/média/alta)
7. **O plano deve ser autocontido** - outro desenvolvedor deve conseguir executá-lo sem contexto adicional

## Formato de Apresentação

Após salvar o arquivo, apresente ao usuário:

```
## ✅ Plano Gerado

**Tipo:** [Feature/Refactor/Bugfix/Migration/Architecture]
**Arquivo:** temp/plano-[tema]-[data].md
**Arquivos afetados:** [N] arquivos
**Complexidade estimada:** [Baixa/Média/Alta]

### Resumo
[2-3 frases resumindo o plano]

### Próximos passos
- Revisar o plano em `temp/plano-[tema]-[data].md`
- Confirmar para iniciar a implementação
```
