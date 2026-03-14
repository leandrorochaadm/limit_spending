# Template: Boas Práticas e Checklist

## Annotations

### @deprecated

```dart
/// Busca produtos usando a API v1.
///
/// Este método está obsoleto e será removido na versão 3.0.
/// Use [fetchProductsV2] para a nova implementação.
@Deprecated('Use fetchProductsV2() instead. Will be removed in v3.0')
Future<List<Product>> fetchProducts() async {
```

### @visibleForTesting

```dart
/// Helper interno para parsing de valores monetários.
///
/// Visível apenas para testes. Não deve ser usado fora da classe.
@visibleForTesting
static double parseMoneyString(String value) {
```

### @protected

```dart
/// Converte [Failure] para mensagem amigável ao usuário.
///
/// Método protegido disponível para subclasses.
@protected
String getErrorMessage(Failure failure) {
```

## Markdown em Doc Comments

### Listas

```dart
/// Gerencia operações de autenticação do usuário.
///
/// Funcionalidades suportadas:
/// * Login com email/senha
/// * Login com biometria
/// * Login social (Google, Facebook, Apple)
/// * Recuperação de senha
/// * Logout
///
/// Todos os métodos retornam [Either<Failure, User>].
```

### Code Blocks

```dart
/// Valida um CPF brasileiro.
///
/// Exemplo:
/// ```dart
/// final isValid = CpfValidator.validate('123.456.789-00');
/// if (isValid) {
///   print('CPF válido');
/// }
/// ```
```

### Links

```dart
/// Implementa autenticação via Firebase Auth.
///
/// Documentação oficial:
/// https://firebase.google.com/docs/auth
///
/// Veja também:
/// * [BiometricHelper] para autenticação biométrica
/// * [SessionHelper] para gerenciar sessões
```

## DO: Boas Práticas

- **Comece com maiúscula e termine com ponto final**
- **Primeira frase = sumário completo isolado**
- **Parágrafos separados por linha em branco**
- **80 caracteres por linha**
- **Verbos na terceira pessoa para métodos**
- **Frases nominais para propriedades**
- **"Whether" para booleanos**
- **Documente o "porquê", não o "o quê"**
- **Colchetes `[]` para identificadores Dart**
- **Exemplos para APIs complexas**
- **Liste Failures possíveis**

## DON'T: O Que Evitar

- **Nunca `/* */` para documentação**
- **Não repita o que o código já diz**
- **Não documente o óbvio**
- **Não deixe documentação desatualizada**
- **Não use linguagem informal**
- **Não documente getters/setters triviais**

## Checklist Antes de Commitar

### Documentação

- [ ] Toda classe pública tem doc comment com sumário
- [ ] Métodos públicos documentados com propósito
- [ ] Parâmetros não óbvios documentados
- [ ] Possíveis Failures listadas
- [ ] Exemplos incluídos quando apropriado
- [ ] Links externos quando relevante
- [ ] Primeira frase faz sentido isoladamente
- [ ] Identificadores com colchetes `[]`
- [ ] Sem erros de português
- [ ] Comentários inline para lógicas complexas
- [ ] TODOs no formato: `// TODO(username): descrição`
- [ ] Usa `ConsoleLogger` ao invés de `print()`

### Revisão de Código

- [ ] Documentação atualizada com mudanças
- [ ] Novos métodos públicos documentados
- [ ] Exemplos de código funcionam
- [ ] Estilo consistente com o projeto
- [ ] Sem comentários redundantes

## Ferramentas

### Gerar Documentação

```bash
dart doc .
dart doc . && open doc/api/index.html
```

### Referências Oficiais

- [Effective Dart: Documentation](https://dart.dev/effective-dart/documentation)
- [Dart API Documentation Guidelines](https://dart.dev/tools/dart-doc)
