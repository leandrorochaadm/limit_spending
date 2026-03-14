---
paths:
  - "lib/features/*/presentation/providers/**"
  - "lib/features/*/providers/**"
  - "lib/features/*/data/repositories/**"
  - "lib/features/*/data/datasources/**"
  - "lib/features/*/domain/usecases/**"
  - "lib/core/providers/**"
---

# Riverpod Rules

## Provider Types - When to Use

| Type | Use When | keepAlive? |
|------|----------|------------|
| `Provider` | DI de services, repositories, usecases (sync, read-only) | Sim |
| `StateNotifierProvider` | Estado mutavel complexo com multiplos metodos | Sim (default) |
| `FutureProvider` | Dados async one-shot sem metodos de mutacao | Depende |
| `StreamProvider` | Streams continuas (WebSocket, Firestore) | Depende |
| `FutureProvider.family` | Dados async parametrizados | autoDispose |

> **Nota:** StateNotifier e totalmente suportado no Riverpod 2.x. Para novos providers, considerar `Notifier`/`AsyncNotifier` quando possivel.

## Dependency Chain (Clean Architecture)

```
DataSource Provider -> Repository Provider -> UseCase Provider -> StateNotifierProvider
     Provider              Provider              Provider         StateNotifierProvider
```

```dart
// LAYER 1: DataSource
final featureRemoteDataSourceProvider = Provider<FeatureRemoteDataSource>((ref) {
  return FeatureRemoteDataSourceImpl(apiClient: ref.watch(apiClientProvider));
});

// LAYER 2: Repository
final featureRepositoryProvider = Provider<FeatureRepository>((ref) {
  return FeatureRepositoryImpl(dataSource: ref.watch(featureRemoteDataSourceProvider));
});

// LAYER 3: UseCase
final getFeatureUseCaseProvider = Provider<GetFeatureUseCase>((ref) {
  return GetFeatureUseCase(ref.watch(featureRepositoryProvider));
});

// LAYER 4: Presentation
final featureProvider = StateNotifierProvider<FeatureNotifier, FeatureState>((ref) {
  return FeatureNotifier(ref);
});
```

## Provider Location

| Provider | Definir em |
|----------|-----------|
| DataSource | Final de `*_remote_data_source.dart` |
| Repository | Final de `*_repository_impl.dart` |
| UseCase | Final de `*_use_case.dart` ou `features/[feature]/providers/` |
| StateNotifier | Final de `*_provider.dart` em `presentation/providers/` |
| Global/Core | `lib/core/providers/` |

## ref.watch vs ref.read vs ref.listen

| Metodo | Onde Usar | Proposito |
|--------|-----------|-----------|
| `ref.watch` | `build()` de widgets e providers | Reativo - rebuild ao mudar. **Escolha padrao.** |
| `ref.read` | Callbacks (`onPressed`), `initState`, dentro de StateNotifier | Leitura unica, sem subscription |
| `ref.listen` | `build()` de widgets | Side-effects (snackbar, navegacao). NAO rebuilda |

### ANTI-PATTERNS CRITICOS

```dart
// ERRADO: ref.read no build - UI nunca atualiza
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.read(myProvider); // BUG!
}

// CORRETO: ref.watch no build
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(myProvider);
}
```

```dart
// ERRADO: ref.watch em callback - subscription desnecessaria
onPressed: () {
  ref.watch(myProvider); // ERRADO!
}

// CORRETO: ref.read em callback
onPressed: () {
  ref.read(myProvider.notifier).doSomething();
}
```

## ref.listen para Side-Effects

```dart
Widget build(BuildContext context, WidgetRef ref) {
  // Side-effect: mostrar snackbar em erro
  ref.listen<FeatureState>(featureProvider, (previous, next) {
    if (next is FeatureError) {
      AppUtils.showSnackBarError(context, message: next.message);
    }
  });

  final state = ref.watch(featureProvider);
  return switch (state) { ... };
}
```

## ref.watch com select (Performance)

```dart
// ERRADO: rebuild em qualquer mudanca do auth state
final isDoctor = ref.watch(authProvider);

// CORRETO: rebuild APENAS quando userType muda
final userType = ref.watch(authProvider.select((state) => state.user?.userType));
```

## autoDispose e keepAlive

### Quando usar autoDispose

| Cenario | Usar |
|---------|------|
| Estado de tela (form, wizard, filtros) | `autoDispose` |
| Providers com `family` | `autoDispose` **SEMPRE** (previne memory leak) |
| Estado temporario de UI | `autoDispose` |
| Services globais (ApiClient, repos) | keepAlive (default) |
| Auth state, user profile | keepAlive (default) |

```dart
// Tela temporaria - autoDispose
final addCardProvider = StateNotifierProvider.autoDispose<AddCardNotifier, AddCardState>((ref) {
  return AddCardNotifier(tokenizeCardUseCase: ref.watch(tokenizeCardUseCaseProvider));
});

// CRITICO: family SEMPRE com autoDispose
final consultationHistoryProvider =
    StateNotifierProvider.autoDispose.family<ConsultationHistoryNotifier, ConsultationHistoryState, String>(
  (ref, patientId) => ConsultationHistoryNotifier(ref, patientId),
);
```

### Cache temporario com autoDispose

```dart
extension CacheForExtension on Ref {
  void cacheFor(Duration duration) {
    final link = keepAlive();
    final timer = Timer(duration, link.close);
    onDispose(timer.cancel);
  }
}

// Uso: cache por 5 minutos
final dataProvider = FutureProvider.autoDispose<Data>((ref) async {
  ref.cacheFor(const Duration(minutes: 5));
  return fetchData();
});
```

## family Modifier

```dart
// Parametro simples
final patientProvider = FutureProvider.autoDispose.family<PatientEntity, String>(
  (ref, patientId) async {
    return ref.watch(patientRepoProvider).getPatient(patientId);
  },
);

// Multiplos parametros - usar Record
final chatProvider = StateNotifierProvider.autoDispose.family<ChatNotifier, ChatState, (String, String)>(
  (ref, params) {
    final (consultationId, userId) = params;
    return ChatNotifier(ref, consultationId: consultationId, userId: userId);
  },
);
```

**Regras de family:**
- **SEMPRE** combinar com `autoDispose` (cada parametro cria cache separado)
- Parametros DEVEM implementar `==` e `hashCode` (primitivos, Equatable, records)
- Preferir Records `(String, int)` para multiplos parametros ao inves de `Map<String, String>`

## StateNotifier - Padrao do Projeto

### Acesso a dependencias no Notifier

```dart
// Padrao A: Ref como campo (preferido para notifiers com muitos usecases)
class FeatureNotifier extends StateNotifier<FeatureState> {
  final Ref _ref;

  FeatureNotifier(this._ref) : super(const FeatureInitial());

  Future<void> fetchData() async {
    final usecase = _ref.read(getFeatureUseCaseProvider);
    final result = await usecase(const NoParams());
    // ...
  }
}

// Padrao B: Injecao direta (preferido para notifiers simples)
class FeatureNotifier extends StateNotifier<FeatureState> {
  final GetFeatureUseCase _getFeatureUseCase;

  FeatureNotifier({required GetFeatureUseCase getFeatureUseCase})
      : _getFeatureUseCase = getFeatureUseCase,
        super(const FeatureInitial());
}
```

## Widgets - Consumo de Providers

### ConsumerWidget (preferido para widgets simples)

```dart
class FeatureScreen extends ConsumerWidget {
  const FeatureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(featureProvider);

    return switch (state) {
      FeatureInitial() => const SizedBox.shrink(),
      FeatureLoading() => const ClyvoLoadingIndicator(),
      FeatureLoaded(:final data) => FeatureContent(data: data),
      FeatureError(:final message) => ClyvoErrorWidget(message: message),
    };
  }
}
```

### ConsumerStatefulWidget (para lifecycle management)

```dart
class FeatureScreen extends ConsumerStatefulWidget {
  const FeatureScreen({super.key});

  @override
  ConsumerState<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends ConsumerState<FeatureScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(featureProvider.notifier).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(featureProvider);
    return switch (state) { ... };
  }
}
```

### Consumer (para widgets funcionais inline)

```dart
Consumer(
  builder: (context, ref, child) {
    final state = ref.watch(featureProvider);
    return Text(state.toString());
  },
)
```

## Disposal e Cleanup

```dart
// Em StateNotifier: override dispose()
class ChatNotifier extends StateNotifier<ChatState> {
  StreamSubscription? _messageSubscription;
  Timer? _typingTimer;

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _typingTimer?.cancel();
    super.dispose();
  }
}

// Em definicao de Provider: ref.onDispose()
final chatServiceProvider = Provider<ChatService>((ref) {
  final service = ChatService();
  ref.onDispose(() => service.dispose());
  return service;
});
```

## Reset de Estado (Logout)

```dart
// ERRADO: invalidar cada provider manualmente
ref.invalidate(providerA);
ref.invalidate(providerB);

// CORRETO: fazer providers dependerem do auth state
final patientsProvider = StateNotifierProvider<PatientsNotifier, PatientsState>((ref) {
  ref.watch(authStateProvider); // Auto-reset quando usuario deslogar
  return PatientsNotifier(ref.watch(getPatientsUseCaseProvider));
});
```

## Anti-Patterns

1. **ref.read no build()** - UI nunca atualiza
2. **Criar providers dentro de widgets** - recreados a cada build
3. **family sem autoDispose** - memory leak
4. **Nao cancelar streams/timers no dispose()** - memory leak
5. **Dependencias circulares** - throw em runtime (A watch B, B watch A)
6. **Logica de negocio no widget** - mover para Notifier
7. **ref.watch como "otimizacao"** - usar `select()` quando precisa filtrar
8. **StateNotifier chamando `state =` apos disposed** - verificar `mounted`

## Naming Conventions

| Tipo | Padrao | Exemplo |
|------|--------|---------|
| Provider (DI) | `{feature}{Layer}Provider` | `patientRepositoryProvider` |
| UseCase Provider | `{action}UseCaseProvider` | `getPatientsUseCaseProvider` |
| DataSource Provider | `{feature}RemoteDataSourceProvider` | `patientRemoteDataSourceProvider` |
| StateNotifier Provider | `{feature}Provider` | `patientsProvider`, `consultationsProvider` |
| Notifier Class | `{Feature}Notifier` | `PatientsNotifier` |
| Computed Provider | `is{Condition}Provider` | `isDoctorProvider` |
| Family Provider | `{feature}ByIdProvider` | `patientByIdProvider` |
