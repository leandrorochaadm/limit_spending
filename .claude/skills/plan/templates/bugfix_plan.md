# Template: Plano de Correção de Bug

Use esta estrutura ao criar planos para correção de bugs e problemas.

---

```markdown
# Plano de Correção: [Descrição curta do bug]

**Data:** [YYYY-MM-DD]
**Tipo:** Bugfix
**Severidade:** [Crítica | Alta | Média | Baixa]
**Módulo afetado:** `[caminho do módulo]`

---

## 1. Descrição do Problema

### Comportamento atual (bug)
[O que está acontecendo de errado]

### Comportamento esperado
[O que deveria acontecer]

### Como reproduzir
1. [Passo 1]
2. [Passo 2]
3. [Resultado inesperado]

### Evidências
[Logs, screenshots, stack traces se disponíveis]

---

## 2. Análise da Causa Raiz

### Investigação realizada
| # | Arquivo analisado | Descoberta |
|---|-------------------|------------|
| 1 | `lib/features/.../file.dart` | [O que foi encontrado] |

### Causa raiz identificada
[Explicação técnica detalhada do porquê o bug ocorre]

### Trecho de código problemático
```dart
// Código que causa o bug
// Arquivo: [caminho]
// Linha(s): [N-M]
```

### Fluxo do bug
```
[Evento trigger] → [Componente A] → [Estado incorreto] → [Bug manifestado]
```

---

## 3. Solução Proposta

### Estratégia de correção
[Descrição da abordagem para corrigir o bug]

### Código corrigido (proposta)
```dart
// Como o código ficará após a correção
```

### Alternativas consideradas
| Alternativa | Prós | Contras | Escolhida? |
|-------------|------|---------|------------|
| [Opção A] | [Prós] | [Contras] | ✅ |
| [Opção B] | [Prós] | [Contras] | ❌ |

---

## 4. Arquivos a Modificar

| # | Arquivo | Modificação | Risco | Complexidade |
|---|---------|-------------|-------|--------------|
| 1 | `lib/features/.../file.dart` | [Descrição da correção] | [Baixo/Médio/Alto] | [Baixa/Média/Alta] |

---

## 5. Efeitos Colaterais

### Arquivos que podem ser impactados
| Arquivo | Relação com a correção | Teste necessário |
|---------|------------------------|------------------|
| `lib/features/.../related.dart` | [Usa o mesmo método/componente] | [Sim/Não] |

### Cenários a testar após a correção
| # | Cenário | Resultado esperado |
|---|---------|-------------------|
| 1 | [Cenário original do bug] | [Bug não ocorre mais] |
| 2 | [Cenário normal - regressão] | [Continua funcionando] |
| 3 | [Edge case relacionado] | [Comportamento correto] |

---

## 6. Ordem de Execução

| Passo | Ação | Verificação |
|-------|------|-------------|
| 1 | [Ex: Corrigir condição no provider] | Compila sem erros |
| 2 | [Ex: Atualizar estado no widget] | Compila + bug corrigido |
| 3 | [Ex: Verificar telas relacionadas] | Sem regressão |

---

## 7. Prevenção Futura

### Como evitar que este bug reapareça
- [Ex: Adicionar validação no input]
- [Ex: Criar teste unitário específico]

### Testes sugeridos
```dart
// Exemplo de teste que previne regressão
test('should [comportamento] when [condição]', () {
  // arrange
  // act
  // assert
});
```

---

## 8. Checklist de Validação

### Correção
- [ ] Causa raiz identificada e documentada
- [ ] Correção aplicada no(s) arquivo(s) correto(s)
- [ ] Código compila sem erros
- [ ] Bug não ocorre mais no cenário original

### Regressão
- [ ] Funcionalidades relacionadas continuam funcionando
- [ ] Nenhum efeito colateral identificado
- [ ] Testes existentes passando

### Qualidade
- [ ] Padrões do projeto respeitados
- [ ] Imports relativos (não `package:clyvo_mobile/`)
- [ ] Linhas com máximo 120 caracteres
```
