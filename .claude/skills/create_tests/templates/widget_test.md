# Template: Widget Test

## Estrutura Completa

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mocks
class AuthNotifierMock extends Mock implements AuthNotifier {}

void main() {
  late AuthNotifierMock authNotifierMock;

  setUp(() {
    authNotifierMock = AuthNotifierMock();
  });

  tearDown(() {
    reset(authNotifierMock);
  });

  group('LoginScreen', () {
    testWidgets('should display error message when login fails', (tester) async {
      // Arrange
      when(() => authNotifierMock.state)
          .thenReturn(const AuthError('Invalid credentials'));

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith((_) => authNotifierMock),
          ],
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('should show loading indicator when authenticating', (tester) async {
      // Arrange
      when(() => authNotifierMock.state)
          .thenReturn(const AuthLoading());

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith((_) => authNotifierMock),
          ],
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should call login when button pressed', (tester) async {
      // Arrange
      when(() => authNotifierMock.state)
          .thenReturn(const AuthInitial());
      when(() => authNotifierMock.login(any(), any()))
          .thenAnswer((_) async {});

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith((_) => authNotifierMock),
          ],
          child: const MaterialApp(home: LoginScreen()),
        ),
      );

      await tester.enterText(find.byKey(const Key('email_field')), 'test@test.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Assert
      verify(() => authNotifierMock.login('test@test.com', 'password123')).called(1);
    });
  });
}
```

## Helper para Pump com Providers

```dart
// Helper reutilizavel
Future<void> pumpWidget(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        home: child,
        // Adicionar se precisar de localizacao
        // localizationsDelegates: AppLocalizations.localizationsDelegates,
        // supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
}

// Uso
testWidgets('example', (tester) async {
  await pumpWidget(
    tester,
    const LoginScreen(),
    overrides: [authProvider.overrideWith((_) => authNotifierMock)],
  );
});
```

## Finders Comuns

```dart
// Por tipo
find.byType(CircularProgressIndicator)
find.byType(TextButton)
find.byType(ListView)

// Por texto
find.text('Login')
find.textContaining('Error')

// Por Key
find.byKey(const Key('login_button'))
find.byKey(const ValueKey('item_123'))

// Por icon
find.byIcon(Icons.close)

// Por widget
find.byWidget(myWidget)

// Por semantics
find.bySemanticsLabel('Submit')

// Descendentes
find.descendant(
  of: find.byType(Card),
  matching: find.text('Title'),
)

// Ancestrais
find.ancestor(
  of: find.text('Title'),
  matching: find.byType(Card),
)
```

## Acoes de Tester

```dart
// Tap
await tester.tap(find.byType(ElevatedButton));
await tester.pump(); // Processa um frame

// Long press
await tester.longPress(find.byKey(const Key('item')));

// Texto
await tester.enterText(find.byType(TextField), 'Hello');

// Scroll
await tester.drag(find.byType(ListView), const Offset(0, -300));
await tester.pumpAndSettle();

// Swipe
await tester.fling(find.byType(Dismissible), const Offset(-300, 0), 1000);

// Esperar animacoes
await tester.pumpAndSettle();

// Pump com duracao
await tester.pump(const Duration(milliseconds: 500));
```

## Testando Navegacao

```dart
testWidgets('should navigate to home on success', (tester) async {
  // Arrange
  when(() => authNotifierMock.state).thenReturn(const AuthAuthenticated());

  // Act
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authProvider.overrideWith((_) => authNotifierMock)],
      child: MaterialApp(
        home: const LoginScreen(),
        routes: {
          '/home': (_) => const HomeScreen(),
        },
      ),
    ),
  );
  await tester.pumpAndSettle();

  // Assert
  expect(find.byType(HomeScreen), findsOneWidget);
});
```

## Testando Dialogs

```dart
testWidgets('should show confirmation dialog', (tester) async {
  // Act
  await pumpWidget(tester, const SettingsScreen());
  await tester.tap(find.text('Delete Account'));
  await tester.pumpAndSettle();

  // Assert
  expect(find.byType(AlertDialog), findsOneWidget);
  expect(find.text('Are you sure?'), findsOneWidget);
});
```

## Cenarios Obrigatorios para Widget

1. **Render inicial**: exibe corretamente
2. **Loading state**: loading indicator
3. **Error state**: mensagem de erro
4. **Empty state**: widget vazio
5. **Interacao**: tap, input
6. **Navegacao**: se aplicavel
