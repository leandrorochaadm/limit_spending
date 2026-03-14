Analise o contexto atual e sugira ações relevantes com base nos arquivos modificados.

## Passos

1. Execute `git status` para ver arquivos não monitorados
2. Execute `git diff main...HEAD --stat` para ver arquivos modificados no branch
3. Analise os caminhos e monte sugestões contextuais
4. Use a ferramenta **AskUserQuestion** com `multiSelect: true`

## Regras para montar as opções (máximo 4)

| Arquivos detectados | Sugestões relevantes |
|---|---|
| `core/error/` ou `core/mixins/` | Criar testes unitários, Gerar diagrama de fluxo |
| `domain/entities/` ou `domain/usecases/` | Criar testes unitários, Gerar diagrama de entidades |
| `presentation/` ou `providers/` | Criar testes de widget/notifier, Gerar diagrama de estados |
| `data/models/` ou `data/datasources/` | Criar testes do repository, Gerar documentação |
| Qualquer arquivo modificado | Revisar PR, Commit |
| Arquivos untracked | Commit |

Escolha apenas as opções mais relevantes para o contexto atual. Adapte os `description` de cada opção para mencionar os arquivos/módulos reais detectados.

## Formato da pergunta

- question: "❯ tem mais alguma coisa que você sugere nesse contexto?"
- header: "Sugestões"
- multiSelect: true

## Após a seleção

Execute cada ação usando as skills correspondentes:
- Testes → skill `create_tests`
- Documentação → skill `documentation`
- Diagrama → skill `diagram`
- Revisar PR → skill `review-pr`
- Commit → skill `commit-message`
