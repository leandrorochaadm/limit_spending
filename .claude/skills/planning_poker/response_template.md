# Template de Resposta — Planning Poker

Use este template INTEGRALMENTE ao apresentar qualquer estimativa. Nunca encurte ou omita seções.

---

```
## 🃏 Planning Poker — [Nome da Tarefa]

**Estimativa: [N] story points**

> [Uma frase resumindo o racional da estimativa. Ex: "Feature de média complexidade com integração superficial via contrato do backend na mesma sprint e cobertura unitária obrigatória por ser fluxo crítico."]

---

### Justificativa Detalhada

#### 📱 Mobile — [X] pontos de complexidade

**O que será feito:**
- `lib/features/[feature]/domain/entities/[name]_entity.dart` → [ação]: complexidade [baixa/média/alta]
- `lib/features/[feature]/data/datasources/[name]_data_source.dart` → [ação]: complexidade [baixa/média/alta]
- `lib/features/[feature]/presentation/screens/[name]_screen.dart` → [ação]: complexidade [baixa/média/alta]
- _(liste todos os arquivos identificados na Fase 2)_

**Por que essa estimativa:**
[Parágrafo concreto referenciando arquivos e padrões encontrados no codebase. Não use texto genérico.
Ex: "A tela de X requer um novo StateNotifier com 3 estados (idle, loading, error), integração com
o widget Y já existente em lib/core/ui/y_widget.dart, e consumo do endpoint Z. O maior risco é o
tratamento de erro W, que exige retry automático."]

**Fatores redutores:**
- [ex: "WidgetX já existe em lib/core/ui/ — economiza ~0,5 dia de desenvolvimento"]
- [ex: "Padrão idêntico ao fluxo de Z em lib/features/z/ — pode ser reaproveitado"]
- _(se não houver, escreva "Nenhum fator redutor identificado")_

---

#### 🖥️ Backend — [X] pontos de complexidade

<!-- ESCOLHA o bloco correto conforme o cenário informado na Fase 1 -->

<!-- CENÁRIO A: Backend na mesma sprint com contrato -->
**Cenário: Backend na mesma sprint — integração superficial via contrato**

**Contrato esperado:**
- Endpoints: `[METHOD] /api/[recurso]` — [descrição do payload/resposta esperada]
- Status codes relevantes: `200`, `422`, `404` (liste os mapeados)
- Autenticação: [Bearer / sem auth / outro]

**O que o Mobile fará:**
- Implementar `[name]_remote_data_source.dart` mapeando o contrato
- Criar fixtures (`test/fixtures/[name].json`) baseadas no contrato para testes
- Usar dados mockados durante desenvolvimento até backend ficar disponível
- Validação ponta a ponta reservada para o final da sprint em conjunto com QA

**Por que essa estimativa:**
[Explique o risco de depender do contrato e a estratégia de integração superficial.
Ex: "A integração é superficial pois o backend estará em desenvolvimento paralelo.
O Mobile implementa as chamadas com base no contrato swagger fornecido, usando
fixtures locais. Se o contrato mudar durante a sprint, o impacto é X horas de ajuste."]

**Risco:** Contrato pode ser alterado mid-sprint → ver seção Riscos abaixo.

<!-- CENÁRIO B: Endpoint já existe / backend pronto -->
<!-- **O que será feito:**
- `[endpoint]`: consumir endpoint existente → complexidade [baixa/média/alta]
- `[modelo]`: mapear response → complexidade [baixa/média/alta]
**Por que essa estimativa:**
[Parágrafo concreto sobre o esforço de integração.]
**Nota:** Backend pronto — sem risco de dependência de sprint. -->

<!-- CENÁRIO C: Sem alteração de backend -->
<!-- **Pontuação: 0 pts**
**Justificativa:** [Explique por que o backend não é afetado.] -->

---

#### 🧪 QA — [X] pontos de complexidade

**O que será feito:**
- **Testes unitários:** `[lista de arquivos/camadas a cobrir]`
- **Testes de widget:** `[telas/componentes]`
- **Testes manuais:** `[fluxos críticos a percorrer]`
- **Dispositivos:** `[quais e por quê — emulador / iOS físico / Android físico]`
- **Integração ponta a ponta:** [sim/não — quando backend da mesma sprint ficar pronto]

**Por que essa estimativa:**
[Parágrafo concreto sobre QA. Ex: "O fluxo de X é crítico (pontuação Alta). Além dos
testes unitários das camadas domain e data, é necessário validar o comportamento em
dispositivo físico iOS por causa do componente Y que se comporta diferente em emulador.
A integração ponta a ponta com o backend acontece ao final da sprint — adiciona +0,5 dia ao QA."]

**Cenários de teste obrigatórios:**
- [ ] Cenário feliz: [descrever o fluxo completo com sucesso]
- [ ] Falha de rede: [descrever comportamento esperado]
- [ ] Timeout na API: [descrever retry e feedback ao usuário]
- [ ] Dados inválidos / validação: [descrever]
- [ ] Modo offline: [descrever — se aplicável]
- [ ] Regressão: [features adjacentes que podem ser impactadas]

---

### Scorecard de Complexidade

| Área | Fatores analisados | Pontuação |
|------|--------------------|-----------|
| 📱 Mobile | Arquivos: [N] \| Camadas: [N] \| Incerteza: [baixa/média/alta] | +[X] pts |
| 🖥️ Backend | Estado: [criação/ajuste/contrato] \| Negócio: [simples/moderado/complexo] | +[X] pts |
| 🧪 QA | Testes: [N] \| Criticidade: [baixa/média/alta] \| Dispositivos: [N] | +[X] pts |
| **Total** | | **[Total] → [N] story points** |

---

### Arquivos Afetados _(base para a estimativa — não é plano de implementação)_

| Arquivo | Ação esperada | Área | Esforço estimado |
|---------|---------------|------|-----------------|
| `lib/features/.../entity.dart` | Criar | Mobile/Domain | Baixo (~1h) |
| `lib/features/.../usecase.dart` | Criar | Mobile/Domain | Médio (~2h) |
| `lib/features/.../screen.dart` | Criar | Mobile/Presentation | Alto (~4h) |
| `test/features/.../test.dart` | Criar | QA | Médio (~2h) |

**Total de arquivos: [N]** | **Esforço estimado total: ~[X]h**

---

### Riscos e Dependências

| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| Contrato do backend mudar mid-sprint | Média | Retrabalho no DataSource e fixtures | Alinhar com backend antes de começar; versionar contrato |
| [outro risco] | Alta/Média/Baixa | [o que pode dar errado] | [como reduzir] |

---

### Recomendação de Fatiamento _(incluir se 8+ pts)_

Considere dividir em:
- **[Sub-tarefa 1]:** [descrição clara] — ~[X] pts
- **[Sub-tarefa 2]:** [descrição clara] — ~[X] pts

---

Concorda com essa estimativa? Há algum contexto que não foi considerado?
```
