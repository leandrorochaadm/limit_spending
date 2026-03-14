---
paths:
  - "lib/features/*/presentation/screens/**"
  - "lib/features/*/presentation/widgets/**"
  - "lib/core/router/**"
  - "lib/core/ui/navigation/**"
---

# Navigation Rules (go_router)

## Princípio Fundamental — Clean Architecture

Navegação pertence **exclusivamente** à Presentation Layer. Domain e Data **NUNCA** conhecem navegação.

```
Widget (ref.listen) → detecta mudança de estado → navega
Provider/UseCase → atualiza estado → NUNCA navega
```

## Métodos de Navegação

### `context.go(path)` — Navegação Declarativa

Reconstrói a stack de navegação com base na hierarquia de rotas configurada.

```dart
// Substitui a stack — rotas irmãs são descartadas
context.go(AppConstants.homeRoute);

// Rotas aninhadas: rotas pai são preservadas
context.go('/home/settings'); // Home permanece na stack
```

**Quando usar:**
- Troca de contexto (login → home, logout → login)
- Redirects de autenticação
- Quando o usuário **NÃO** deve voltar à tela anterior
- **Preferir SEMPRE que possível** (recomendação da documentação oficial)

**Características:**
- Atualiza a URL no web
- Funciona com deep links
- Stack anterior é descartada para rotas irmãs

### `context.push(path)` — Navegação Imperativa

Empilha a nova rota **sobre** a stack atual, preservando todo o histórico.

```dart
// Adiciona rota no topo — botão voltar funciona
context.push(AppConstants.consultationDetailsRoute, extra: consultation);
```

**Quando usar:**
- Telas de detalhe (consulta, perfil, etc.)
- Modals e bottom sheets
- Fluxos onde o contexto anterior é relevante

**Características:**
- **NÃO** atualiza a URL no web (a partir do go_router 8.0+)
- Deep linking problemático (URL não reflete o estado real)

### `context.pushReplacement(path)` — Substituir Rota Atual

Substitui **apenas** a rota atual na stack, sem reconstruir toda a hierarquia como `go`.

```dart
// Step 1 → Step 2: substitui step1 pelo step2, mantendo o que veio antes
context.pushReplacement(AppConstants.registrationStep2Route);
```

**Quando usar:**
- Fluxos wizard/multi-step (step1 → step2 → step3) onde voltar ao step anterior não faz sentido
- Substituir tela atual mantendo a stack abaixo intacta

**Diferença de `go`:** `go` reconstrói toda a stack com base na hierarquia. `pushReplacement` troca só o topo.

### `context.pop()` — Voltar

Remove a rota atual da stack, retornando à anterior.

```dart
// SEMPRE verificar se pode voltar antes de chamar pop
if (context.canPop()) {
  context.pop();
}

// Com resultado (para fluxos que esperam retorno)
context.pop(result);
```

**`context.canPop()`** — Verificar antes de pop. Evita comportamento inesperado ao tentar pop em stack vazia (ex: deep link que abre direto numa tela de detalhe).

### `context.goNamed()` / `context.pushNamed()` — Navegação por Nome

Mesmo comportamento de `go`/`push`, mas usando nomes ao invés de paths.

```dart
context.goNamed('home');
context.pushNamed(
  'consultation-details',
  pathParameters: {'id': consultationId},
);
```

### Tabela Resumo

| Método | Stack | URL Web | Deep Link | Caso de Uso |
|--------|-------|---------|-----------|-------------|
| `context.go()` | Reconstrói | Atualiza | Funciona | Troca de contexto, redirects |
| `context.push()` | Empilha | Não atualiza | Problemático | Detalhes, modals, sub-telas |
| `context.pushReplacement()` | Substitui topo | Não atualiza | Problemático | Wizards, multi-step flows |
| `context.goNamed()` | Reconstrói | Atualiza | Funciona | `go()` com nome de rota |
| `context.pushNamed()` | Empilha | Não atualiza | Problemático | `push()` com nome de rota |
| `context.pop()` | Remove topo | — | — | Voltar (usar `canPop()` antes) |

## Passagem de Dados entre Rotas

### Path Parameters — Dados obrigatórios na URL

```dart
// Definição da rota
GoRoute(
  path: '/doctor-profile/:id',
  builder: (context, state) {
    final doctorId = state.pathParameters['id'] ?? '';
    return DoctorProfileScreen(doctorId: doctorId);
  },
)

// Navegação
context.push('/doctor-profile/$doctorId');
```

### Query Parameters — Dados opcionais na URL

```dart
// Definição da rota
GoRoute(
  path: '/video-call',
  builder: (context, state) {
    final isDoctor = state.uri.queryParameters['isDoctor'] == 'true';
    return VideoCallScreen(isDoctor: isDoctor);
  },
)

// Navegação
context.push('/video-call?isDoctor=true');
```

### `state.extra` — Objetos complexos (não serializado na URL)

```dart
// Navegação
context.push(AppConstants.consultationDetailsRoute, extra: consultationEntity);

// Recebimento com cast
final consultation = state.extra as ConsultationEntity?;
```

**Cuidados com `extra`:**
- **NÃO** sobrevive a refresh de página no web (não é serializado na URL)
- Usar para objetos que já estão em memória
- **SEMPRE** ter fallback para buscar dados via ID quando `extra` for null
- Para múltiplos valores, usar `Map<String, dynamic>`

## Constantes de Rotas

**NUNCA** hardcodar paths. Usar `AppConstants` de `lib/core/constants/app_constants.dart`.

```dart
// ERRADO
context.go('/consultation/details/123');

// CORRETO
context.go('${AppConstants.consultationDetailsRoute}/$id');
```

## Navegação Reativa com Riverpod

Usar `ref.listen` para side-effects de navegação. **NUNCA** navegar dentro do Provider/UseCase.

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  ref.listen<AuthState>(authProvider, (previous, next) {
    if (next is AuthSuccess) {
      context.go(AppConstants.homeRoute);
    }
  });

  final state = ref.watch(authProvider);
  return switch (state) { ... };
}
```

## Redirects e Guards

### Redirect Global (no GoRouter)

```dart
GoRouter(
  refreshListenable: routerRefreshNotifier, // re-avalia redirects
  redirect: (context, state) {
    final isLoggedIn = /* verificar auth state */;
    final isOnLoginPage = state.matchedLocation == AppConstants.loginRoute;

    if (!isLoggedIn && !isOnLoginPage) return AppConstants.loginRoute;
    if (isLoggedIn && isOnLoginPage) return AppConstants.homeRoute;
    return null; // sem redirect
  },
)
```

### Guard por Rota

```dart
GoRoute(
  path: '/admin',
  redirect: (context, state) {
    final isAdmin = /* check */;
    return isAdmin ? null : '/unauthorized';
  },
  builder: (_, __) => const AdminScreen(),
)
```

### Prevenção de Loops

O GoRouter tem `redirectLimit` padrão de **5 iterações**. Condições de redirect devem ser **mutuamente exclusivas** para evitar loops infinitos.

## Regras do Projeto (Clyvo)

### Padrões estabelecidos

- Router configurado como Riverpod Provider (`routerProvider`)
- `RouterRefreshNotifier` (ChangeNotifier) como ponte entre Riverpod state e `refreshListenable`
- Rotas centralizadas em `AppConstants` (`lib/core/constants/app_constants.dart`)
- Deep links via `DeepLinkService` (`lib/core/services/deep_link_service.dart`)
- Bottom navigation diferenciada por tipo de usuário (doctor/patient) em `ClyvoBottomNavigationBar`
- Logging de navegação com `ConsoleLogger` (tags: `ROUTER_NAV`, `ROUTER_DEBUG`)
- Tela 404 via `NotFoundScreen` no `errorBuilder` do GoRouter

### Estrutura de arquivos

```
lib/core/
  router/
    app_router.dart               # GoRouter config + redirects + todas as rotas
    router_refresh_notifier.dart  # ChangeNotifier para refresh de redirects
    locale_aware_router.dart      # Extensions de navegação locale-aware
    router_export.dart            # Exports públicos
  services/
    deep_link_service.dart        # Parsing e mapeamento de deep links
  constants/
    app_constants.dart            # Constantes de rotas e deep links
  ui/navigation/
    clyvo_bottom_navigation_bar.dart  # Tab navigation por tipo de usuário
```

## Anti-Patterns

### 1. Usar `push` quando deveria usar `go`

```dart
// ERRADO — push após login mantém login na stack
context.push(AppConstants.homeRoute);

// CORRETO — go substitui a stack
context.go(AppConstants.homeRoute);
```

### 2. Usar `Navigator.push` / `Navigator.pop` para rotas

```dart
// ERRADO — bypass do go_router, perde redirects e deep links
Navigator.of(context).push(MaterialPageRoute(builder: (_) => MyScreen()));

// CORRETO — usar go_router
context.push(AppConstants.myScreenRoute);

// EXCEÇÃO: Navigator.pop() é aceitável para fechar dialogs e bottom sheets
Navigator.of(context).pop();
```

### 3. Lógica de negócio dentro das definições de rota

```dart
// ERRADO — business logic no router
GoRoute(
  path: '/dashboard',
  builder: (context, state) {
    final user = fetchUser(); // NÃO
    if (user.isPremium) return PremiumDashboard();
    return FreeDashboard();
  },
)

// CORRETO — router só roteia, lógica no Provider
GoRoute(
  path: '/dashboard',
  builder: (_, __) => const DashboardScreen(),
)
```

### 4. Paths hardcoded

```dart
// ERRADO
context.go('/home');

// CORRETO
context.go(AppConstants.homeRoute);
```

### 5. Navegar dentro de Provider/UseCase

```dart
// ERRADO — Provider navegando
class AuthNotifier extends StateNotifier<AuthState> {
  void login() async {
    // ... login logic
    context.go('/home'); // NUNCA
  }
}

// CORRETO — Widget reage ao estado e navega
ref.listen<AuthState>(authProvider, (prev, next) {
  if (next is AuthSuccess) context.go(AppConstants.homeRoute);
});
```

### 6. Criar GoRouter dentro de `build()`

```dart
// ERRADO — recria router a cada rebuild, perde estado de navegação
Widget build(BuildContext context) {
  final router = GoRouter(...);
  return MaterialApp.router(routerConfig: router);
}

// CORRETO — declarar como Provider
final routerProvider = Provider<GoRouter>((ref) => GoRouter(...));
```

## Memory Leaks — Navegação

- `ScrollController`, `TextEditingController`, `AnimationController` devem ser disposed em `dispose()`
- `StreamSubscription` deve ser cancelada no `dispose()`
- `Timer` e `Timer.periodic` devem ser cancelados no `dispose()`
- `addListener` deve ter `removeListener` correspondente no `dispose()`
- Verificar `mounted` antes de navegar após operações async
