Gere uma mensagem de commit curta e simples para os arquivos alterados.

Siga o padrão Conventional Commits:
- `feat`: nova funcionalidade
- `fix`: correção de bug
- `chore`: tarefas de manutenção
- `refactor`: refatoração de código
- `docs`: documentação
- `style`: formatação
- `test`: testes

Formato: `type(scope): descrição curta`

## Scope
Use `->` para indicar hierarquia de pastas/módulos:
- `core->enum` - arquivo em core/enum
- `features->consultation` - arquivo em features/consultation
- `features->patient->domain` - arquivo em features/patient/domain

Exemplos:
- `refactor(core->enum): rename status values`
- `fix(features->consultation): error appClient instance`
- `feat(features->patient>domain): create TriageQuestionEntity`
- `chore(analysis): update linter rules`

Passos:
1. Execute `git status` e `git diff` para ver as mudanças
2. Analise o contexto e o caminho dos arquivos alterados
3. Gere TRÊS opções de mensagem de commit curtas (máximo 80 caracteres cada)
4. Apresente as 3 opções numeradas e prontas para uso
