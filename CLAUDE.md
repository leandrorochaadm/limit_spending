col# Regras de Desenvolvimento - Clyvo Mobile

## Estatísticas do Projeto
- **784 arquivos Dart** | **25 features** | **Clean Architecture + Riverpod**

## Comunicação
- **SEMPRE** responder em Português do Brasil
- Linguagem simples, direta e concisa
- **SEMPRE** usar termos técnicos e **SEMPRE** explicar brevemente o termo (ex: "sealed class (classe selada que força tratamento exaustivo de todos os estados)")

## Princípios Chave
- Código Dart conciso e técnico
- Clean Architecture + Riverpod (StateNotifierProvider)
- Nomes descritivos com verbos auxiliares (isLoading, hasError)
- Inglês para código e documentação
- Use `const` para widgets e variáveis imutáveis
- Vírgulas finais para melhor formatação

## Estrutura de Features
```
features/[feature_name]/
  ├── data/
  │   ├── datasources/        # [feature]_remote_data_source.dart
  │   ├── models/             # [model]_model.dart (estende Entity)
  │   ├── repositories/       # [feature]_repository_impl.dart
  │   └── services/           # [service]_service.dart
  ├── domain/
  │   ├── entities/           # [entity]_entity.dart (Equatable)
  │   ├── repositories/       # [feature]_repository.dart (interface)
  │   └── usecases/           # [action]_use_case.dart
  └── presentation/
      ├── providers/
      │   ├── [feature]_provider.dart
      │   └── [feature]_state.dart  # Sealed classes SEPARADO!
      ├── screens/            # [screen]_screen.dart
      └── widgets/            # [widget]_widget.dart
```

## Features Existentes (25)
| Categoria | Features |
|-----------|----------|
| Auth/Onboarding | auth, onboarding, splash |
| Usuários | patient, patients, doctor, profile, medical_user |
| Consultas | consultation, teleconsultation, call |
| IA/Voz | voice_assistant, ai_assistant |
| Financeiro | payment, wallet, prescription |
| Suporte | help, settings, notifications |
| Documentos | certificate, digital_signature, patient_id |
| Outros | home, specialty, ui_showcase |

## Regras Detalhadas (carregadas sob demanda)

Regras detalhadas por camada estão em `.claude/rules/` e são carregadas automaticamente conforme os arquivos editados:

| Rule | Paths | Conteúdo |
|------|-------|----------|
| `data-layer.md` | `lib/features/*/data/**` | DataSources, Models, Repositories, API |
| `domain-layer.md` | `lib/features/*/domain/**` | Entities, UseCases |
| `presentation-layer.md` | `lib/features/*/presentation/**` | States, Providers, Styling |
| `core-enums.md` | `lib/core/enum/**` | Enhanced enums |
| `core-reference.md` | `lib/core/**` | Referência completa lib/core |
| `logging.md` | `lib/**/*.dart` | LoggerMixin, log levels |
| `layout.md` | `presentation/**`, `ui/**` | Layout flexível |
| `navigation.md` | `presentation/screens/**`, `core/router/**` | go_router, context.go/push, redirects, deep links |
| `testing.md` | `test/**` | Testes com Mocktail |
| `riverpod.md` | `providers/**`, `usecases/**`, `repositories/**` | Riverpod + Provider patterns |
| `backend.md` | `scripts/**` | Deploy e ambientes |
| `architecture.md` | *(sempre)* | Clean Architecture layers |
| `naming.md` | *(sob demanda — use `@.claude/rules/naming.md`)* | Convenções de nomenclatura completas |

Templates de código em `.claude/rules/templates/` (datasource, model, repository, entity, usecase, state, provider, enum).

## Validação de Requisitos (SEMPRE aplicar)

### Antes de implementar
- **SEMPRE pergunte** quando algo não estiver claro — não presuma requisitos
- **Confirme o entendimento** listando o que entendeu e peça confirmação
- **Questione a abordagem:** considere alternativas mais simples
- **Verifique contexto:** "Isso afeta [feature relacionada]?"
- **Valide aderência** ao Clean Architecture e padrões do projeto
- **Sugira** a abordagem mais simples que resolve o problema
- **Use** soluções já existentes no projeto quando possível

### Formato de validação
```
Entendi que você quer:
[lista o que foi entendido]

Vou implementar:
[lista o que será feito]

Dúvidas/Sugestões:
[lista dúvidas ou alternativas]

Confirma?
```

### Durante e após implementação
- **Comunique** decisões de design não óbvias e trade-offs
- **Resuma** o que foi feito e liste arquivos alterados/criados

## Regras Críticas
- **NUNCA** adicionar funcionalidades sem autorização expressa
- **NUNCA** criar arquivos .md sem solicitação
- **NUNCA** executar comandos git sem autorização
- **NUNCA** criar widgets duplicados da biblioteca (verificar `lib/core/ui/`)
- Linhas com máximo 120 caracteres
- Dispose controllers em `dispose()`
- Verificar `mounted` após operações async

## Limpeza de Supressões de Análise (SEMPRE aplicar)

Ao editar qualquer arquivo `.dart`:
1. Verificar se o arquivo contém `// ignore_for_file:` na primeira linha
2. Se sim, **remover essa linha** antes de salvar
3. Após editar o arquivo, rodar `flutter analyze [caminho_do_arquivo]`
