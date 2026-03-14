# Template: Documentação de Widgets e Screens

## Widget Customizado — Design system e props

```dart
/// Um botão customizado seguindo o design system do app.
///
/// Este widget encapsula o estilo padrão de botões, incluindo
/// cores, espaçamento, estados de loading e disabled.
///
/// Exemplo de uso:
/// ```dart
/// ClyvoButton(
///   text: 'Solicitar Saque',
///   onPressed: () => _requestWithdraw(),
///   isLoading: state is WithdrawLoading,
/// )
/// ```
///
/// Veja também:
/// * [ClyvoActionButton] para botões de ação
/// * [ClyvoPrimaryButton] para botões primários
class ClyvoButton extends StatelessWidget {
```

## Construtor — Propriedades obrigatórias e opcionais

```dart
  /// Cria um [ClyvoButton].
  ///
  /// [text] é obrigatório e não pode estar vazio.
  /// [onPressed] pode ser null para botões desabilitados.
  const ClyvoButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
  }) : assert(text != '', 'Text cannot be empty');
```

## Propriedades — Documente comportamento

```dart
  /// O texto exibido no botão.
  final String text;

  /// Callback executado quando o botão é pressionado.
  ///
  /// Se null, o botão ficará desabilitado.
  final VoidCallback? onPressed;

  /// Whether o botão está em estado de loading.
  ///
  /// Quando true, exibe um [CircularProgressIndicator] e desabilita o botão.
  final bool isLoading;

  /// Cor de fundo customizada do botão.
  ///
  /// Se null, usa [AppColors.primary].
  final Color? backgroundColor;
```

## Screens — Rota e requisitos

```dart
/// Tela de solicitação de saque.
///
/// Permite o usuário informar o valor desejado e solicitar um saque.
/// Valida o valor mínimo, exibe o saldo disponível e histórico de saques.
///
/// Requer que o usuário esteja autenticado e tenha saldo disponível.
class WithdrawScreen extends ConsumerWidget {
  /// Rota desta tela.
  static const routeName = '/withdraw';

  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(withdrawProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar Saque')),
      body: _buildBody(context, ref, state),
    );
  }
}
```

## ConsumerStatefulWidget — Lifecycle

```dart
/// Tela de chat da consulta.
///
/// Gerencia conexão WebSocket, envio de mensagens e scroll automático.
/// Requer [consultationId] para identificar a consulta.
class ChatScreen extends ConsumerStatefulWidget {
  /// O ID da consulta associada ao chat.
  final String consultationId;

  const ChatScreen({super.key, required this.consultationId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}
```

## Checklist

- [ ] Widget tem doc comment com propósito
- [ ] Exemplo de uso incluído para widgets reutilizáveis
- [ ] Construtor documenta props obrigatórias
- [ ] Props nullable documentam valor padrão
- [ ] Booleanos usam "Whether"
- [ ] Screens documentam rota e requisitos
- [ ] Referencia widgets relacionados com `[]`
