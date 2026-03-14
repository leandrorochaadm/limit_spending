# Template: Plano de Refatoração

Use esta estrutura ao criar planos para refatoração de código existente.

---

```markdown
# Plano de Refatoração: [Nome/Escopo]

**Data:** [YYYY-MM-DD]
**Tipo:** Refactor
**Complexidade:** [Baixa | Média | Alta]
**Módulo afetado:** `[caminho do módulo]`

---

## 1. Objetivo

### O que será refatorado
[Descrição clara do código que será refatorado]

### Por que refatorar
[Motivação: código duplicado, violação de padrão, performance, legibilidade, etc.]

### Resultado esperado
[Como o código ficará após a refatoração - padrões aplicados, melhorias de qualidade]

---

## 2. Estado Atual (Antes)

### Problemas identificados
| # | Problema | Arquivo | Linha(s) | Severidade |
|---|----------|---------|----------|------------|
| 1 | [Ex: Código duplicado] | `lib/features/.../file.dart` | 45-80 | [Alta/Média/Baixa] |

### Métricas atuais
- **Linhas de código afetadas:** [N]
- **Arquivos afetados:** [N]
- **Duplicações encontradas:** [N]
- **Violações de padrão:** [N]

### Código atual (trechos relevantes)
```dart
// Exemplo do código problemático atual
// [trecho de código real do codebase]
```

---

## 3. Estado Desejado (Depois)

### Melhorias planejadas
| # | Melhoria | Padrão aplicado | Benefício |
|---|----------|-----------------|-----------|
| 1 | [Ex: Extrair widget reutilizável] | [DRY/SOLID/Clean Arch] | [Reduz duplicação] |

### Código proposto (trechos relevantes)
```dart
// Exemplo de como o código ficará após refatoração
```

---

## 4. Estratégia de Refatoração

### Abordagem
[Ex: Refatoração incremental / Big bang / Strangler pattern]

### Garantia de não-regressão
[Como garantir que nada quebra: testes existentes, testes novos, verificação manual]

---

## 5. Arquivos a Modificar

| # | Arquivo | Modificação | Risco | Complexidade |
|---|---------|-------------|-------|--------------|
| 1 | `lib/features/.../file.dart` | [Descrição da mudança] | [Baixo/Médio/Alto] | [Baixa/Média/Alta] |

---

## 6. Arquivos a Criar (se necessário)

| # | Arquivo | Descrição | Motivo |
|---|---------|-----------|--------|
| 1 | `lib/core/...` | [Novo componente extraído] | [Ex: Widget reutilizável extraído de 3 telas] |

---

## 7. Arquivos a Remover (se necessário)

| # | Arquivo | Motivo | Substituído por |
|---|---------|--------|-----------------|
| 1 | `lib/features/.../old_file.dart` | [Código movido/consolidado] | `lib/features/.../new_file.dart` |

---

## 8. Ordem de Execução

Siga esta ordem para manter o código compilando em cada passo:

| Passo | Ação | Arquivo(s) | Verificação |
|-------|------|-----------|-------------|
| 1 | [Ex: Criar novo widget] | `lib/core/ui/...` | Compila sem erros |
| 2 | [Ex: Substituir uso no screen A] | `lib/features/.../screen_a.dart` | Compila + funciona |
| 3 | [Ex: Substituir uso no screen B] | `lib/features/.../screen_b.dart` | Compila + funciona |
| 4 | [Ex: Remover código antigo] | `lib/features/.../old_widget.dart` | Sem referências órfãs |

**IMPORTANTE:** O código deve compilar após cada passo. Nunca deixe o projeto em estado quebrado entre passos.

---

## 9. Impacto e Dependências

### Arquivos que importam os modificados
| Arquivo modificado | Importado por |
|--------------------|---------------|
| `lib/features/.../file.dart` | `screen_a.dart`, `screen_b.dart` |

### Features afetadas
| Feature | Impacto | Teste necessário |
|---------|---------|------------------|
| [feature_name] | [Direto/Indireto] | [Sim/Não] |

---

## 10. Riscos e Mitigações

| Risco | Impacto | Probabilidade | Mitigação |
|-------|---------|---------------|-----------|
| [Ex: Quebrar tela existente] | Alto | Baixa | [Testar cada tela após mudança] |
| [Ex: Perder funcionalidade] | Alto | Baixa | [Comparar comportamento antes/depois] |

---

## 11. Checklist de Validação

### Antes de iniciar
- [ ] Código atual compila sem erros
- [ ] Testes existentes passando (se houver)
- [ ] Branch limpa (sem mudanças uncommitted)

### Durante a refatoração
- [ ] Código compila após cada passo
- [ ] Nenhuma funcionalidade removida acidentalmente
- [ ] Imports atualizados em todos os arquivos afetados

### Após concluir
- [ ] Código compila sem erros
- [ ] Testes existentes passando
- [ ] Nenhum import órfão ou referência quebrada
- [ ] Padrões do projeto respeitados (Clean Architecture, nomenclatura)
- [ ] Imports relativos (não `package:clyvo_mobile/`)
- [ ] Linhas com máximo 120 caracteres
- [ ] Código duplicado eliminado
- [ ] Nenhum widget duplicado de `lib/core/ui/`
```
