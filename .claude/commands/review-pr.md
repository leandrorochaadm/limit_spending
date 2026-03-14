Faça um code review do PR informado, analisando apenas arquivos `.dart` no diff.

## Contexto

- Repositório: clyvo-mobile
- Use as regras do CLAUDE.md do projeto como referência
- Use o `@.claude/rules/core-reference.md` como referência dos componentes disponíveis em `lib/core/`
- Foque apenas em melhorias, não elogie o que está bom

## O que analisar

1. **Bugs potenciais** - Erros de lógica, null safety, async/await incorreto
2. **Padrões do projeto** - Violações das regras do CLAUDE.md
3. **Segurança** - Exposição de dados sensíveis, validações faltando
4. **Performance** - Rebuilds desnecessários, operações custosas
5. **Código morto** - Código comentado, imports não utilizados, TODOs pendentes
6. **DRY / Reutilização do core** - Código que duplica algo já existente em `lib/core/`
7. **Riverpod** - Uso incorreto de `ref.watch`/`ref.read`, providers sem `autoDispose`, state após disposal
8. **Clean Architecture** - Camadas acessando layers errados, boundaries violados
9. **Navegação** - Uso incorreto de `context.go()` vs `context.push()`
10. **Memory leaks** - Streams, subscriptions, listeners ou timers não cancelados no `dispose()`
11. **Naming conventions** - Arquivos e classes fora do padrão da estrutura de features
12. **Melhorias gerais** - Legibilidade, manutenibilidade

## Validação DRY com lib/core

Consulte o arquivo `.claude/core-reference.md` para identificar violações DRY. Valide se o PR:

- Cria widgets que já existem em `lib/core/ui/` (botões, inputs, cards, dialogs, feedback, navigation, screens, widgets)
- Cria utilitários que já existem em `lib/core/utils/` ou `lib/core/extensions/`
- Cria formatadores que já existem em `lib/core/formatters/`
- Cria tratamento de erro sem usar `lib/core/error/` (exceptions e failures)
- Cria enums que já existem em `lib/core/enum/`
- Cria serviços que duplicam `lib/core/services/`
- Usa cores hardcoded (`Color(0xFF...)`, `Colors.red`, etc) em vez de `AppColors` de `lib/core/theme/app_colors.dart`
- Usa estilos de texto hardcoded (`TextStyle(...)`) em vez de `AppStyles` de `lib/core/theme/app_styles.dart`
- Usa `print()` em vez de `ConsoleLogger` de `lib/core/logging/`
- Trata imagens sem usar `lib/core/images/`
- Faz validações que já existem em `lib/core/utils/validators.dart`

## Tom das mensagens

- Escreva como um humano escreveria, de forma natural
- Tom explicativo e confiante
- Sem emojis ou categorização visual
- Linguagem simples e direta em português
- Não faça perguntas inseguras como "O que acha?" ou "Faz sentido?"

### Exemplos de tom correto:

```
O `print()` funciona, mas o `ConsoleLogger` é o padrão do projeto e facilita filtrar logs por tag.
```

```
Esse código comentado pode ser removido pra manter o arquivo limpo.
```

```
Faltou o `await` aqui, o que pode causar comportamento inesperado na execução.
```

```
Essa cor está hardcoded. Usa `AppColors.primary` de `lib/core/theme/app_colors.dart` pra manter consistência com o design system.
```

```
Esse `TextStyle` manual pode ser substituído por `AppStyles.s14w500gray` de `lib/core/theme/app_styles.dart`.
```

```
Já existe um `ClyvoSearchField` em `lib/core/ui/inputs/`. Não precisa criar um novo campo de busca.
```

```
Aqui tá usando `ref.read` dentro do `build()`. Troca pra `ref.watch` pra que o widget reaja quando o estado mudar.
```

```
A tela de presentation tá importando direto de `data/datasources/`. O correto é acessar pelo domain (usecase ou repository).
```

```
Aqui usou `context.go()` pra abrir um detalhe, mas isso substitui a stack. Usa `context.push()` pra manter a navegação anterior.
```

```
Esse `StreamSubscription` não tá sendo cancelado no `dispose()`. Pode causar memory leak.
```

## Fluxo de trabalho — NUNCA comentar direto no GitHub sem permissão

### Etapa 1: Análise (silenciosa)
1. Leia o arquivo `@.claude/rules/core-reference.md` para conhecer os componentes disponíveis
2. Execute `gh pr diff $ARGUMENTS` para obter o diff do PR
3. Filtre apenas arquivos `.dart`
4. Analise cada mudança considerando as regras do CLAUDE.md e a referência do core
5. Compile internamente a lista de comentários com arquivo, linha e texto

### Etapa 2: Aprovação individual (um por um)
Para CADA comentário encontrado, apresente ao usuário no formato:

```
**[arquivo]:[linha]**
[comentário]
```

Pergunte ao usuário se deseja enviar esse comentário ao GitHub.
- Se o usuário aprovar: poste como **inline comment** na linha exata do código usando a API `gh api repos/.../pulls/.../comments`
- Se o usuário rejeitar: descarte e passe para o próximo
- Se o usuário quiser editar: aceite a versão editada e poste essa

### Etapa 3: Finalização
Após passar por todos os comentários, informe o total de comentários postados vs descartados.

### Regras críticas de publicação
- **NUNCA** postar comentários no GitHub sem aprovação explícita do usuário
- **NUNCA** postar como review body (texto único) — SEMPRE usar inline comments na linha do código
- **NUNCA** postar todos de uma vez — sempre um por um com aprovação individual
- Se não encontrar nenhum ponto de melhoria, apenas informe: "Tudo certo, não encontrei pontos de melhoria."

## Regras para validar

Consulte TODAS as regras detalhadas conforme os arquivos tocados no PR:

| Rule | Quando consultar | Conteúdo |
|------|------------------|----------|
| `@.claude/rules/architecture.md` | Sempre | Clean Architecture layers, data flow, regras de importação entre camadas |
| `@.claude/rules/data-layer.md` | Arquivos em `data/` | DataSources, Models, Repositories, API endpoints, ExceptionHandlerMixin |
| `@.claude/rules/domain-layer.md` | Arquivos em `domain/` | Entities (Equatable), UseCases, Repository interfaces, type safety |
| `@.claude/rules/presentation-layer.md` | Arquivos em `presentation/` | Sealed states, Providers, Styling (AppColors/AppStyles), type safety |
| `@.claude/rules/riverpod.md` | Providers, UseCases, Repositories, DataSources | ref.watch/read/listen, autoDispose, family, disposal, anti-patterns |
| `@.claude/rules/logging.md` | Qualquer `.dart` | LoggerMixin, ConsoleLogger, nunca print()/debugPrint() |
| `@.claude/rules/layout.md` | Arquivos em `presentation/`, `ui/` | Layout flexível, Spacer/Expanded, SafeArea, imports relativos |
| `@.claude/rules/core-enums.md` | Arquivos em `lib/core/enum/` | Enhanced enums, name property, fromString factory |
| `@.claude/rules/core-reference.md` | Sempre (validação DRY) | Componentes existentes em lib/core/ |
| `@.claude/rules/navigation.md` | Arquivos em `presentation/screens/`, `presentation/widgets/`, `core/router/` | go_router, context.go/push, redirects, deep links, anti-patterns |
| `@.claude/rules/testing.md` | Arquivos em `test/` | Mocktail, estrutura de testes, padrões por camada |
| `@.claude/rules/backend.md` | Arquivos em `scripts/`, `server/` | Deploy, ambientes, scripts |

## O que NÃO comentar

- Tamanho/comprimento de linhas (não comentar sobre linhas longas ou limite de 120 caracteres)
