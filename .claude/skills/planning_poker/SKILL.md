---
name: planning_poker
description: Facilita sessões de Planning Poker para estimativa de tarefas. Use quando o usuário pedir para estimar uma tarefa, história de usuário, refatoração ou qualquer trabalho de desenvolvimento com Planning Poker. Trigger: "planning poker", "estimativa", "estimar tarefa", "estimar história", "quantos pontos", "story points".
argument-hint: [descrição da tarefa ou caminho do código]
allowed-tools: Read, Grep, Glob
---

# Skill: Planning Poker Facilitador

Facilita sessões de Planning Poker usando perguntas de múltipla escolha para coletar informações com precisão, analisa o codebase quando necessário e fornece estimativa detalhada — considerando **Mobile, Backend e QA** — em story points (Fibonacci).

---

## ⛔ RESTRIÇÕES ABSOLUTAS — NUNCA VIOLAR

1. **NUNCA modificar nenhum arquivo de código** — esta skill é 100% somente leitura
2. **NUNCA criar planos de implementação** — o output é exclusivamente a carta de estimativa com justificativas
3. **NUNCA sugerir como implementar** — liste arquivos afetados apenas para embasar a estimativa, não para instruir o desenvolvimento
4. **A Fase 2 (análise do codebase) é READ-ONLY** — use apenas `Read`, `Grep` e `Glob` para entender o contexto; jamais escreva, edite ou crie arquivos
5. **O único output desta skill é a carta de Planning Poker** com pontuação e justificativas detalhadas

---

## Escala Fibonacci

| Pontos | Significado | Referência de tamanho |
|--------|-------------|----------------------|
| 1 | Trivial | Alterar texto, cor, constante isolada |
| 2 | Simples | Novo campo em form, widget simples, ajuste de layout |
| 3 | Pequena | Nova tela simples + 1 endpoint existente |
| 5 | Média | Feature com estado + UI + integração backend |
| 8 | Grande | Feature completa com novo endpoint + testes |
| 13 | Muito grande | Múltiplas features integradas ou refatoração arquitetural |
| 21 | Épico | NUNCA estimar como 21 — fatiar obrigatoriamente |

---

## Fluxo de Execução

### FASE 0 — Definition of Ready

**Execute ANTES de qualquer pergunta.** Verifique se a tarefa tem contexto mínimo para ser estimada com confiança.

#### Checklist de Definition of Ready

- [ ] **Descrição** — A tarefa tem pelo menos uma frase explicando o que precisa ser feito?
- [ ] **Usuário** — Sabemos quem executa a ação (paciente, médico, sistema)?
- [ ] **Resultado esperado** — Há ao menos um critério de "pronto" identificável?
- [ ] **Escopo delimitado** — A tarefa não depende de uma decisão de produto ainda não tomada?
- [ ] **Sem bloqueio imediato** — Não há dependência externa que impede o início do trabalho?

**Se 3 ou mais itens estiverem desmarcados:** informe ao usuário que a tarefa não está pronta para estimativa e liste o que precisa ser definido antes. Não avance para a FASE 1.

**Se 1-2 itens estiverem desmarcados:** registre como risco/incerteza, faça perguntas focadas nos gaps durante a FASE 1 e adicione +1 pt de risco na área correspondente.

---

### FASE 1 — Coleta Iterativa com Múltipla Escolha

**REGRA FUNDAMENTAL:** Use a ferramenta `AskUserQuestion` com opções de múltipla escolha para CADA pergunta. Nunca faça perguntas abertas se há opções claras. Continue fazendo rodadas de perguntas até ter 100% de clareza nos 5 critérios abaixo.

#### Critérios de Clareza (100% obrigatório antes de estimar)

- [ ] **ESCOPO** — O que exatamente será feito
- [ ] **USUÁRIO** — Quem se beneficia e qual o fluxo
- [ ] **PRONTO** — Critérios de aceitação definidos
- [ ] **TÉCNICO** — Camadas e sistemas envolvidos (mobile, backend, QA)
- [ ] **RISCO** — Incertezas e dependências conhecidas

Se qualquer critério estiver vago após uma rodada, faça nova rodada focada nas lacunas.

---

#### 1.1 Rodada Inicial — Tipo e Escopo

Sempre comece com estas perguntas usando `AskUserQuestion`:

**Pergunta 1 — Tipo de trabalho:**
```
Opções:
- Feature nova (nunca existiu no produto)
- Melhoria de feature existente
- Refatoração (sem mudança de comportamento)
- Correção de bug
- Spike / investigação técnica
```

**Pergunta 2 — Quem realiza a ação:**
```
Opções:
- Paciente
- Médico
- Ambos (fluxos distintos)
- Admin / sistema interno
- Não se aplica (infra/técnico)
```

**Pergunta 3 — Sistemas envolvidos:**
```
Opções (múltipla escolha):
- Apenas Mobile (app)
- Mobile + Backend (novo endpoint ou mudança de API)
- Mobile + Backend + Banco de dados (schema novo ou migração)
- Apenas Backend (sem alteração no app)
- Integração com serviço externo (ex: FCM, Stripe, Twilio...)
```

**Pergunta 4 — Tem caminho de código para analisar?:**
```
Opções:
- Sim, tenho o caminho (ex: lib/features/prescription/)
- Sei a feature, mas não o caminho exato
- É algo completamente novo, sem código existente
```

**Pergunta 5 — Há design (Figma) pronto para esta tarefa?:**
```
Opções:
- Sim, design completo e aprovado
- Sim, mas é rascunho / ainda pode mudar
- Não, precisa ser definido durante o desenvolvimento
- Não se aplica (tarefa técnica sem UI)
```

> Se "rascunho" ou "não": registre como fator de incerteza no Mobile (+1 ou +2 pts conforme o caso). O desenvolvedor precisará tomar decisões de layout/UX que normalmente seriam do designer.

---

#### 1.2 Rodada de Profundidade — Mobile

Se a task envolver telas novas ou acesso a recursos do dispositivo, pergunte:

**Pergunta 6 — A task requer permissões de sistema operacional?:**
```
Opções (múltipla escolha):
- Não, sem acesso a recursos do dispositivo
- Câmera (tirar foto, escanear QR)
- Microfone (gravação de voz, chamada)
- Localização (GPS, geofencing)
- Notificações push (FCM / APNs)
- Biometria (FaceID, impressão digital)
- Armazenamento (galeria, arquivos locais)
- Bluetooth / NFC
```

> Cada permissão nova envolve: configuração no `AndroidManifest.xml` e `Info.plist`, lógica de solicitação em runtime, tratamento de negação pelo usuário e testes em dispositivo físico (emuladores não simulam bem biometria, câmera e Bluetooth). Adicione +1 pt por permissão nova não já tratada no projeto.

---

#### 1.3 Rodada de Profundidade — Backend

Se a resposta incluir backend, pergunte:

**Pergunta 7 — Estado do backend:**
```
Opções:
- Endpoint já existe, só precisa consumir no app
- Endpoint precisa ser criado do zero
- Endpoint existe mas precisa de alteração
- Não sei o estado do backend
```

**Pergunta 8 — Complexidade do backend:**
```
Opções:
- CRUD simples (sem regra de negócio complexa)
- Tem regra de negócio significativa (validações, cálculos, fluxos)
- Envolve autenticação / autorização especial
- Envolve integrações com serviços externos (pagamento, notificação, etc.)
- Envolve migração de dados existentes
```

**Pergunta 9 — Quem faz o backend?:**
```
Opções:
- Backend na mesma sprint — fornecerá contrato (swagger/schema) para integração superficial
- Time separado (já está pronto ou será feito em paralelo)
- Eu faço (fullstack)
- Não sei ainda
```

> **Se "Backend na mesma sprint com contrato":** O mobile faz integração superficial baseada no contrato fornecido (endpoints, payloads, status codes). Isso significa:
> - Mobile implementa DataSource/Repository com chamadas reais ao contrato
> - Pode usar dados mockados/fixtures enquanto o backend não está pronto
> - A integração final (validação ponta a ponta) vai para QA ao final da sprint
> - Adicione 1 ponto de risco por dependência de contrato estar correto/completo

---

#### 1.4 Rodada de Profundidade — QA

Sempre pergunte sobre QA:

**Pergunta 10 — Cobertura de QA esperada:**
```
Opções (múltipla escolha):
- Testes unitários (camadas domain/data)
- Testes de widget (UI)
- Testes de integração / E2E
- Testes manuais em dispositivo real
- Testes em múltiplos dispositivos (iOS + Android)
- Testes de regressão de features existentes
```

**Pergunta 11 — Criticidade do fluxo:**
```
Opções:
- Baixa — funcionalidade auxiliar, falha não bloqueia o usuário
- Média — funcionalidade importante, mas tem alternativa
- Alta — fluxo crítico (pagamento, autenticação, assinatura, prescrição)
```

---

#### 1.5 Rodada de Profundidade — Riscos

**Pergunta 12 — Nível de incerteza técnica:**
```
Opções:
- Sei exatamente como implementar, já fiz algo similar
- Tenho boa ideia, mas alguns detalhes precisam ser validados
- Conheço o problema, mas a solução não é clara
- Alta incerteza — pode precisar de spike antes
```

**Pergunta 13 — Há dependências bloqueantes?:**
```
Opções:
- Não, posso começar agora
- Sim, depende de outra tarefa do mobile
- Sim, depende do backend estar pronto
- Sim, depende de decisão de produto/design
- Sim, depende de terceiro externo (API externa, contrato, etc.)
```

---

#### 1.6 Critérios de Aceitação

Se não foram fornecidos, pergunte com texto aberto:

> "Descreva os critérios de aceitação: o que precisa funcionar para considerar essa tarefa concluída?"

Se o usuário não souber, ofereça:

**Pergunta 14 — Quer que eu sugira critérios de aceitação com base no que foi descrito?:**
```
Opções:
- Sim, sugira e eu valido
- Não, vou descrever agora
```

---

### FASE 2 — Análise do Codebase

**OBRIGATÓRIO quando houver feature ou caminho de código identificado.**

#### 2.1 Mapear arquivos

```
Glob: lib/features/[feature]/**/*.dart
Glob: test/features/[feature]/**/*.dart
Glob: lib/core/ui/**/*.dart  ← verificar widgets reutilizáveis
```

#### 2.2 Analisar por camada

**Domain:**
- Entities novas ou modificadas? Quantas?
- UseCases novos ou modificados? Quantos?

**Data:**
- DataSource novo ou modificado?
- Models novos ou modificados?
- Repository impl precisa de alteração?

**Presentation:**
- Telas novas ou modificadas? Quantas?
- Novos estados (sealed class)?
- Novo Provider/StateNotifier?
- Widgets reutilizáveis disponíveis em `lib/core/ui/`?

**Testes (QA técnico):**
- Arquivos de teste afetados? Quantos?
- Fixtures a criar/atualizar?
- Mocks a criar/atualizar?

#### 2.3 Verificar padrões similares

Use `Grep` para encontrar padrões análogos no projeto — reduz estimativa quando há reutilização.

---

### FASE 3 — Matriz de Complexidade

> **Template de resposta:** use sempre `.claude/skills/planning_poker/response_template.md` — o template tem os 3 cenários de backend (contrato/pronto/sem backend) como blocos comentados. Escolha o correto e remova os outros.


Preencha a tabela com base nas respostas e análise do código:

#### 3.1 Mobile

| Fator | Baixo (+0) | Médio (+1) | Alto (+2) |
|-------|-----------|-----------|---------|
| Arquivos afetados | 1-3 | 4-8 | 9+ |
| Camadas envolvidas | 1 | 2 | 3+ |
| Estado/navegação nova | Não | Simples | Complexa |
| Widgets reutilizáveis | Todos disponíveis | Parcial | Nenhum |
| Incerteza técnica mobile | Solução clara | Algumas dúvidas | Desconhecido |
| Design/Figma | Completo e aprovado | Rascunho / pode mudar | Sem design — dev decide layout |
| Permissões de SO | Nenhuma nova | 1 permissão já usada no projeto | Permissão nova (não usada antes) |

#### 3.2 Backend

| Fator | Baixo (+0) | Médio (+1) | Alto (+2) |
|-------|-----------|-----------|---------|
| Estado do endpoint | Já existe | Alterar existente | Criar do zero |
| Complexidade de negócio | CRUD simples | Regras moderadas | Regras complexas/integrações |
| Banco de dados | Sem mudança | Query nova | Schema/migração |
| Autenticação/autorização | Sem mudança | Ajuste | Nova política |
| Feito pelo mesmo time | Não (paralelo) | Sim, simples | Sim, complexo |
| Integração via contrato | Contrato completo e estável | Contrato parcial/rascunho | Sem contrato definido |

#### 3.3 QA

| Fator | Baixo (+0) | Médio (+1) | Alto (+2) |
|-------|-----------|-----------|---------|
| Testes unitários a criar | 0-3 | 4-8 | 9+ |
| Testes de widget | Não | Simples | Complexos |
| Criticidade do fluxo | Baixa | Média | Alta |
| Dispositivos a validar | Emulador basta | iOS ou Android | Ambos + físico |
| Risco de regressão | Isolado | Módulo adjacente | Feature core |

#### 3.4 Conversão para Fibonacci

| Pontuação total | Story Points |
|----------------|-------------|
| 0-2 | **1-2 pts** |
| 3-5 | **3 pts** |
| 6-8 | **5 pts** |
| 9-11 | **8 pts** |
| 12-14 | **13 pts** |
| 15+ | **Fatiar obrigatoriamente** |

---

### FASE 4 — Estimativa com Justificativa Detalhada

**REGRA:** A justificativa deve ser específica, com referências ao código encontrado na Fase 2 e às respostas coletadas na Fase 1. NUNCA use justificativas genéricas.

#### Formato obrigatório de apresentação:

```
## 🃏 Planning Poker — [Nome da Tarefa]

**Estimativa: [N] story points**

---

### Justificativa Detalhada

#### 📱 Mobile — [X] pontos de complexidade

**O que será feito:**
- [arquivo concreto]: [ação específica] → complexidade [baixa/média/alta]
- [arquivo concreto]: [ação específica] → complexidade [baixa/média/alta]
- ...

**Por que essa estimativa:**
[Parágrafo explicando o raciocínio. Ex: "A tela de assinatura exige um novo
StateNotifier com 4 estados (idle, signing, success, error), integração com o
widget de canvas já existente em lib/core/ui/signature_pad.dart, e consumo do
endpoint POST /prescriptions/{id}/sign. O ponto mais custoso é o tratamento
de erro de timeout da API de assinatura, que exige retry automático."]

**Fatores redutores:**
- [ex: "SignaturePadWidget já existe em lib/core/ui/ — economiza ~1 dia"]
- [ex: "padrão idêntico ao fluxo de payment — pode ser reusado"]

---

#### 🖥️ Backend — [X] pontos de complexidade

**O que será feito:**
- [endpoint/serviço]: [ação específica] → complexidade [baixa/média/alta]
- [modelo/schema]: [mudança específica] → complexidade [baixa/média/alta]

**Por que essa estimativa:**
[Parágrafo com raciocínio concreto sobre backend. Ex: "O endpoint de assinatura
precisa validar o certificado digital, gravar o hash do documento e acionar o
serviço externo de timestamping. A integração com serviço externo é o maior
risco — se a API deles tiver latência alta, pode impactar UX."]

**Nota:** Cenários de responsabilidade backend:
- *Backend na mesma sprint com contrato:* Mobile faz integração superficial (DataSource + fixtures). Risco: contrato pode mudar. Validação ponta a ponta vai para o final da sprint.
- *Backend por outro time / já pronto:* Este ponto não afeta o sprint do mobile — mas é risco de dependência a ser acompanhado.
- *Sem backend:* Justifique explicitamente por que 0 pontos foram atribuídos.

---

#### 🧪 QA — [X] pontos de complexidade

**O que será feito:**
- Testes unitários: [lista de arquivos/camadas a cobrir]
- Testes de widget: [telas/componentes a validar]
- Testes manuais: [fluxos críticos a percorrer]
- Dispositivos: [quais e por quê]

**Por que essa estimativa:**
[Parágrafo com raciocínio de QA. Ex: "O fluxo de assinatura é crítico (erro
aqui invalida a prescrição). Além dos testes unitários das camadas domain e data,
é necessário validar o comportamento do canvas de assinatura em dispositivos
físicos iOS e Android — emuladores não refletem o comportamento real do touch.
Isso adiciona complexidade significativa ao QA."]

**Cenários de teste obrigatórios:**
- [ ] Cenário feliz: [descrever]
- [ ] Falha de rede durante: [descrever]
- [ ] Timeout na API de: [descrever]
- [ ] Comportamento em modo offline: [descrever]
- [ ] Regressão: [features que podem ser impactadas]

---

### Scorecard de Complexidade

| Área | Fatores analisados | Pontuação |
|------|--------------------|-----------|
| Mobile | [N] fatores | +[X] pts |
| Backend | [N] fatores | +[X] pts |
| QA | [N] fatores | +[X] pts |
| **Total** | | **[Total] → [N] story points** |

---

### Arquivos Afetados

| Arquivo | Ação | Área | Esforço |
|---------|------|------|---------|
| lib/features/.../entity.dart | Criar | Mobile/Domain | Baixo |
| lib/features/.../usecase.dart | Criar | Mobile/Domain | Médio |
| lib/features/.../screen.dart | Criar | Mobile/Presentation | Alto |
| test/features/.../test.dart | Criar | QA | Médio |

**Total de arquivos: N**

---

### Riscos e Dependências

| Risco | Probabilidade | Impacto | Mitigação |
|-------|--------------|---------|-----------|
| [risco 1] | Alta/Média/Baixa | [o que pode dar errado] | [como reduzir] |
| [risco 2] | Alta/Média/Baixa | [o que pode dar errado] | [como reduzir] |

---

### Recomendação de Fatiamento (se 8+ pts)

Considere dividir em:
- **[Sub-tarefa 1]:** [descrição] — ~[X] pts
- **[Sub-tarefa 2]:** [descrição] — ~[X] pts

---

Concorda com essa estimativa? Há algum contexto que não foi considerado?
```

---

## Regras Críticas

1. **NUNCA estime antes de ter os 5 critérios de clareza preenchidos** — faça mais rodadas de perguntas
2. **SEMPRE use múltipla escolha** com `AskUserQuestion` — perguntas abertas só quando necessário
3. **SEMPRE analise o codebase** quando houver feature identificada — estimativa sem código é chute
4. **SEMPRE inclua Backend e QA** na estimativa — mesmo que sejam 0 pontos, justifique por quê
5. **NUNCA use 21** — tarefas nesse tamanho devem ser fatiadas antes de estimar
6. **SEMPRE referencie código real** na justificativa — nomes de arquivos, classes, patterns encontrados
7. **SEMPRE apresente o scorecard** por área (Mobile / Backend / QA) com pontuação individual
8. **Continue perguntando** se a resposta for ambígua — clareza total vale mais que velocidade
9. **SEMPRE use o template completo da FASE 4** ao apresentar a estimativa — NUNCA responda apenas com o número de pontos; a justificativa detalhada é obrigatória em TODA estimativa
10. **Backend na mesma sprint com contrato:** Mobile faz integração superficial baseada no contrato — registre isso explicitamente na seção Backend e nos Riscos (risco: contrato mudar mid-sprint)
11. **NUNCA criar, editar ou escrever arquivos** — análise de código é somente leitura (`Read`, `Grep`, `Glob` apenas)
12. **NUNCA criar plano de implementação** — a seção "Arquivos Afetados" é apenas insumo para embasar a estimativa, não um plano de execução
13. **O produto final desta skill é exclusivamente a carta de estimativa** — nada mais

---

## Exemplos de Estimativa

### Exemplo 1 — Feature simples (3 pts)
**Tarefa:** "Adicionar campo de telefone secundário no perfil do médico"
- Mobile (+2): 1 campo na entity, 1 em AppTextField existente, atualizar tela
- Backend (+0): endpoint existente, só adicionar campo nullable
- QA (+1): 3 testes unitários a atualizar, 1 validação manual

### Exemplo 2 — Feature média (8 pts)
**Tarefa:** "Notificação push quando consulta for confirmada"
- Mobile (+3): nova entidade, 2 UseCases, Provider + tela de notificações
- Backend (+3): integração FCM, novo campo no schema, lógica de trigger
- QA (+2): fluxo crítico, iOS + Android com token FCM real

### Exemplo 3 — Refatoração grande (13 pts)
**Tarefa:** "Migrar auth de ChangeNotifier para Riverpod StateNotifier"
- Mobile (+5): 20+ arquivos afetados, 3 camadas, navegação baseada em estado
- Backend (+0): sem mudança
- QA (+4): todos os testes de auth precisam ser reescritos, risco de regressão na navegação global
