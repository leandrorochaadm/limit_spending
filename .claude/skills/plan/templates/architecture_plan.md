# Template: Plano de Decisão Arquitetural

Use esta estrutura ao criar planos para decisões técnicas que envolvem trade-offs significativos.

---

```markdown
# Decisão Arquitetural: [Título da Decisão]

**Data:** [YYYY-MM-DD]
**Tipo:** Architecture Decision
**Status:** [Proposta | Aprovada | Implementada]
**Impacto:** [Baixo | Médio | Alto]

---

## 1. Contexto

### Situação atual
[Descreva o estado atual do sistema e por que uma decisão arquitetural é necessária]

### Problema/Necessidade
[Qual problema precisa ser resolvido ou qual necessidade precisa ser atendida]

### Restrições
- [Ex: Deve manter compatibilidade com API existente]
- [Ex: Deve funcionar offline]
- [Ex: Não pode aumentar o tamanho do APK significativamente]

### Stakeholders
| Quem | Interesse |
|------|----------|
| [Ex: Equipe mobile] | [Performance, manutenibilidade] |
| [Ex: Backend] | [Compatibilidade de API] |

---

## 2. Opções Avaliadas

### Opção A: [Nome da opção]

**Descrição:** [Como funcionaria]

**Arquitetura proposta:**
```
[Diagrama ASCII ou descrição da arquitetura]
```

**Prós:**
- [Vantagem 1]
- [Vantagem 2]

**Contras:**
- [Desvantagem 1]
- [Desvantagem 2]

**Impacto no codebase:**
| Aspecto | Impacto |
|---------|---------|
| Arquivos novos | [N] |
| Arquivos modificados | [N] |
| Complexidade | [Baixa/Média/Alta] |
| Risco de regressão | [Baixo/Médio/Alto] |

**Exemplo de implementação:**
```dart
// Código exemplo mostrando como ficaria
```

---

### Opção B: [Nome da opção]

**Descrição:** [Como funcionaria]

**Arquitetura proposta:**
```
[Diagrama ASCII ou descrição da arquitetura]
```

**Prós:**
- [Vantagem 1]
- [Vantagem 2]

**Contras:**
- [Desvantagem 1]
- [Desvantagem 2]

**Impacto no codebase:**
| Aspecto | Impacto |
|---------|---------|
| Arquivos novos | [N] |
| Arquivos modificados | [N] |
| Complexidade | [Baixa/Média/Alta] |
| Risco de regressão | [Baixo/Médio/Alto] |

**Exemplo de implementação:**
```dart
// Código exemplo mostrando como ficaria
```

---

### Opção C: [Nome da opção] (se aplicável)

[Mesma estrutura das opções anteriores]

---

## 3. Análise Comparativa

### Matriz de decisão
| Critério | Peso | Opção A | Opção B | Opção C |
|----------|------|---------|---------|---------|
| Performance | [1-5] | [1-5] | [1-5] | [1-5] |
| Manutenibilidade | [1-5] | [1-5] | [1-5] | [1-5] |
| Complexidade de implementação | [1-5] | [1-5] | [1-5] | [1-5] |
| Aderência ao projeto | [1-5] | [1-5] | [1-5] | [1-5] |
| Escalabilidade | [1-5] | [1-5] | [1-5] | [1-5] |
| Risco | [1-5] | [1-5] | [1-5] | [1-5] |
| **Total ponderado** | - | **[N]** | **[N]** | **[N]** |

### Impacto em features existentes
| Feature | Opção A | Opção B | Opção C |
|---------|---------|---------|---------|
| [auth] | [Nenhum/Baixo/Médio/Alto] | [...] | [...] |
| [consultation] | [...] | [...] | [...] |

---

## 4. Decisão Recomendada

### Opção escolhida: [Opção X]

### Justificativa
[Explicação clara de por que esta opção é a melhor escolha dado o contexto e restrições]

### Trade-offs aceitos
- [O que estamos abrindo mão ao escolher esta opção]
- [Riscos que estamos aceitando]

---

## 5. Plano de Implementação

### Arquivos a criar
| # | Arquivo | Descrição | Complexidade |
|---|---------|-----------|--------------|
| 1 | `lib/...` | [Descrição] | [Baixa/Média/Alta] |

### Arquivos a modificar
| # | Arquivo | Modificação | Risco |
|---|---------|-------------|-------|
| 1 | `lib/...` | [Descrição] | [Baixo/Médio/Alto] |

### Ordem de execução
| Passo | Ação | Verificação |
|-------|------|-------------|
| 1 | [Ação] | [Como verificar] |

---

## 6. Métricas de Sucesso

### Como saber se a decisão foi boa
| Métrica | Valor atual | Valor esperado | Como medir |
|---------|-------------|----------------|------------|
| [Ex: Tempo de resposta] | [200ms] | [<100ms] | [Benchmark] |
| [Ex: Linhas de código] | [500] | [<300] | [cloc] |

### Sinais de alerta (quando reconsiderar)
- [Ex: Se a performance piorar em mais de 20%]
- [Ex: Se a complexidade de manutenção aumentar significativamente]

---

## 7. Riscos e Mitigações

| Risco | Impacto | Probabilidade | Mitigação |
|-------|---------|---------------|-----------|
| [Risco 1] | [Alto/Médio/Baixo] | [Alta/Média/Baixa] | [Como mitigar] |

---

## 8. Referências

- [Link ou arquivo relevante 1]
- [Link ou arquivo relevante 2]
- [Documentação do padrão/tecnologia escolhida]

---

## 9. Checklist de Validação

- [ ] Todas as opções viáveis foram avaliadas
- [ ] Trade-offs documentados e aceitos
- [ ] Impacto em features existentes mapeado
- [ ] Plano de implementação concreto
- [ ] Métricas de sucesso definidas
- [ ] Riscos identificados com mitigações
- [ ] Decisão alinhada com Clean Architecture do projeto
- [ ] Componentes de `lib/core/` considerados antes de criar novos
```
