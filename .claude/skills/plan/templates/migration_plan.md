# Template: Plano de Migração

Use esta estrutura ao criar planos para migração de tecnologias, APIs, padrões ou dependências.

---

```markdown
# Plano de Migração: [De X para Y]

**Data:** [YYYY-MM-DD]
**Tipo:** Migration
**Complexidade:** [Baixa | Média | Alta]
**Escopo:** [N] arquivos em [N] features

---

## 1. Objetivo

### O que será migrado
[Ex: Migrar de StateNotifier para AsyncNotifier, de API v1 para v2, etc.]

### De (estado atual)
[Tecnologia/padrão/versão atual]

### Para (estado desejado)
[Tecnologia/padrão/versão alvo]

### Motivação
[Por que esta migração é necessária: deprecation, performance, padrão novo, etc.]

---

## 2. Escopo da Migração

### Inventário completo
| # | Arquivo | Feature | Status atual | Complexidade |
|---|---------|---------|-------------|--------------|
| 1 | `lib/features/.../file.dart` | [feature] | [A migrar] | [Baixa/Média/Alta] |

### Resumo por feature
| Feature | Arquivos a migrar | Complexidade total |
|---------|-------------------|-------------------|
| [auth] | [N] | [Baixa/Média/Alta] |

### Fora do escopo
[O que NÃO será migrado e por quê]

---

## 3. Análise de Compatibilidade

### Breaking changes
| # | Mudança | Impacto | Arquivos afetados |
|---|---------|---------|-------------------|
| 1 | [Ex: Assinatura do método mudou] | [Todos os consumers] | [N] arquivos |

### Compatibilidade retroativa
[A migração pode ser feita de forma incremental? Ambos os padrões podem coexistir?]

### Dependências externas afetadas
| Pacote | Versão atual | Versão necessária | Breaking? |
|--------|-------------|-------------------|-----------|
| [riverpod] | [2.x] | [3.x] | [Sim/Não] |

---

## 4. Estratégia de Migração

### Abordagem escolhida
[Ex: Incremental por feature / Big bang / Adapter pattern / Strangler fig]

### Justificativa
[Por que esta abordagem foi escolhida]

### Fases
| Fase | Escopo | Duração estimada | Objetivo |
|------|--------|-------------------|---------|
| 1 | [Preparação] | - | [Criar adapters/abstrações] |
| 2 | [Migração core] | - | [Migrar infraestrutura base] |
| 3 | [Migração features] | - | [Migrar feature por feature] |
| 4 | [Limpeza] | - | [Remover código legado] |

---

## 5. Padrão Antes vs Depois

### Antes (código atual)
```dart
// Exemplo real do padrão atual no codebase
```

### Depois (código migrado)
```dart
// Como ficará após a migração
```

### Guia de conversão rápida
| Antes | Depois | Notas |
|-------|--------|-------|
| `StateNotifier<T>` | `AsyncNotifier<T>` | [Nota] |
| `state = ...` | `state = AsyncData(...)` | [Nota] |

---

## 6. Ordem de Execução Detalhada

### Fase 1: Preparação
| Passo | Ação | Arquivo(s) | Verificação |
|-------|------|-----------|-------------|
| 1.1 | [Ex: Atualizar pubspec] | `pubspec.yaml` | `flutter pub get` ok |
| 1.2 | [Ex: Criar adapter] | `lib/core/...` | Compila |

### Fase 2: Migração Core
| Passo | Ação | Arquivo(s) | Verificação |
|-------|------|-----------|-------------|
| 2.1 | [Ex: Migrar base classes] | `lib/core/...` | Compila |

### Fase 3: Migração por Feature
| Passo | Feature | Arquivo(s) | Verificação |
|-------|---------|-----------|-------------|
| 3.1 | [auth] | `lib/features/auth/...` | Compila + funciona |
| 3.2 | [patient] | `lib/features/patient/...` | Compila + funciona |

### Fase 4: Limpeza
| Passo | Ação | Arquivo(s) | Verificação |
|-------|------|-----------|-------------|
| 4.1 | [Ex: Remover adapters] | `lib/core/...` | Sem referências órfãs |
| 4.2 | [Ex: Remover imports antigos] | Vários | Compila |

**REGRA:** O código deve compilar após CADA passo. Nunca pule passos.

---

## 7. Rollback Plan

### Ponto de não retorno
[A partir de qual passo não é viável reverter facilmente]

### Como reverter (antes do ponto de não retorno)
```bash
# Comandos ou passos para reverter
```

### Como reverter (após o ponto de não retorno)
[Estratégia alternativa se precisar abandonar a migração]

---

## 8. Riscos e Mitigações

| Risco | Impacto | Probabilidade | Mitigação |
|-------|---------|---------------|-----------|
| [Ex: Incompatibilidade de tipos] | Alto | Média | [Criar testes de tipo antes] |
| [Ex: Performance degradada] | Médio | Baixa | [Benchmark antes/depois] |
| [Ex: Feature quebrada] | Alto | Média | [Testar cada feature isolada] |

---

## 9. Testes de Validação

### Testes existentes que devem continuar passando
```bash
# Listar testes relevantes
flutter test test/features/[feature]/
```

### Testes novos necessários
| # | Teste | Objetivo |
|---|-------|----------|
| 1 | [Ex: Teste de integração] | [Validar migração end-to-end] |

---

## 10. Checklist de Validação

### Pré-migração
- [ ] Inventário completo de arquivos a migrar
- [ ] Testes existentes passando
- [ ] Branch limpa
- [ ] Backup/commit do estado atual

### Durante migração
- [ ] Código compila após cada passo
- [ ] Nenhuma feature quebrada
- [ ] Padrão novo aplicado corretamente

### Pós-migração
- [ ] Todos os arquivos migrados (inventário zerado)
- [ ] Código legado removido
- [ ] Sem imports órfãos
- [ ] Testes existentes passando
- [ ] Padrões do projeto respeitados
- [ ] Imports relativos (não `package:clyvo_mobile/`)
- [ ] Linhas com máximo 120 caracteres
- [ ] `flutter analyze` sem erros
```
