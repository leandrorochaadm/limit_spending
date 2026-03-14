# Template: Regras de Doc Comments Dart

## Estrutura Básica

```dart
/// [SUMÁRIO EM UMA FRASE - PRIMEIRA LINHA].
///
/// [Descrição detalhada em parágrafos subsequentes, se necessário.
/// Use uma linha em branco para separar parágrafos.]
///
/// [Informações sobre parâmetros, retorno, exceções em prosa.]
///
/// [Exemplos de uso, se relevante.]
```

## Regras de Formatação

- **Use `///`** — nunca `/** */` ou `/* */`
- **Frases completas** — maiúscula no início, ponto final no fim
- **Primeira linha = sumário** — deve fazer sentido isoladamente
- **Separe o sumário** — linha em branco após a primeira frase
- **Parágrafos** — separe blocos com linha em branco
- **80 caracteres** por linha de comentário

## Padrões de Verbos

### Funções/Métodos — Terceira Pessoa

```dart
/// Calcula o saldo disponível para saque do usuário.
///
/// Considera o saldo atual, transações pendentes e limites da conta.
/// Retorna um [Either] com [Failure] em caso de erro ou [double] com o saldo.
Future<Either<Failure?, double>> calculateAvailableBalance() async {
```

```dart
/// Valida se o CPF fornecido é válido.
///
/// Retorna `true` se o CPF passar na validação de dígitos verificadores.
bool validateCpf(String cpf) {
```

### Variáveis/Propriedades — Frases Nominais

```dart
/// O saldo atual da carteira do produtor.
///
/// Este valor é atualizado em tempo real quando novas transações ocorrem.
final double walletBalance;

/// A lista de produtos afiliados do usuário.
///
/// Contém apenas produtos com status ativo ou pendente.
final List<Product> affiliateProducts;
```

### Booleanos — "Whether"

```dart
/// Whether o usuário está autenticado no sistema.
final bool isAuthenticated;

/// Whether a conexão com a internet está disponível.
final bool isOnline;

/// Whether o saque está sendo processado.
final bool isProcessingWithdraw;
```

### Classes — Frases Nominais

```dart
/// Um datasource para gerenciar operações de saque.
///
/// Esta classe é responsável por fazer chamadas à API de saques,
/// tratar erros e converter respostas em models.
class WithdrawDataSource implements WithdrawRepository {
```

### Enums — Propósito

```dart
/// Status possíveis de uma solicitação de afiliação.
///
/// Representa o ciclo de vida de uma solicitação desde a criação
/// até sua aprovação ou recusa.
enum AffiliationStatus {
  /// Solicitação aguardando análise do produtor.
  pending,

  /// Solicitação aprovada pelo produtor.
  approved,

  /// Solicitação recusada pelo produtor.
  refused,
}
```

## Referências com Colchetes

```dart
/// Carrega os dados do [User] a partir do [userId] fornecido.
///
/// Retorna um [Either] contendo [UserSessionFailure] se a sessão expirou,
/// [OfflineFailure] se não há conexão, ou os dados do [User] em caso de sucesso.
///
/// Veja também:
/// * [SessionHelper] para gerenciar sessões de usuário
/// * [ConnectivityHelper] para verificar conectividade
```

## Links Externos

```dart
/// Implementa autenticação biométrica seguindo as guidelines do Flutter.
///
/// Baseado em: https://pub.dev/packages/local_auth
///
/// Veja também:
/// * https://developer.android.com/training/sign-in/biometric-auth
/// * https://developer.apple.com/documentation/localauthentication
```

## Comentários Inline (//)

### Quando Usar

```dart
/// Calcula o saldo total da carteira do usuário.
Future<double> calculateWalletBalance() async {
  // Busca transações dos últimos 30 dias para otimizar performance
  final transactions = await _getRecentTransactions(days: 30);

  // Aplica regra de negócio: comissões são creditadas após 7 dias
  final availableBalance = transactions
      .where((t) => t.createdAt.isBefore(DateTime.now().subtract(Duration(days: 7))))
      .fold(0.0, (sum, t) => sum + t.amount);

  return availableBalance;
}
```

### Workarounds e TODOs

```dart
// TODO(username): Descrição da tarefa a ser feita
// TODO(username): Migrar para nova API v2, https://github.com/org/repo/issues/123

// FIXME: Cálculo incorreto para valores acima de R$ 10.000
// Issue: https://github.com/org/repo/issues/456
```

## Comentários de Supressão (ignore)

```dart
// ignore_for_file: lines_longer_than_80_chars

// ignore: avoid_print
print('Debug: valor = $value');
```
