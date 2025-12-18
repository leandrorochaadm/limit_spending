# Recomendações de Melhorias - Limit Spending

> Análise detalhada de problemas, oportunidades de melhoria e roadmap de implementação

**Data da Análise**: 2025-12-18
**Versão do Projeto**: 0.1.0

---

## 📊 Resumo Executivo

### Métricas do Projeto

| Métrica | Valor | Status |
|---------|-------|--------|
| **Arquivos Dart** | ~100 | ✅ Organizado |
| **Features** | 5 | ✅ Modular |
| **Linhas de Código** | ~5000 | ✅ Pequeno/Médio |
| **Cobertura de Testes** | 0% | 🔴 Crítico |
| **Dependências** | 4 prod / 1 dev | ⚠️ Minimalista |
| **Regras de Segurança** | 0 | 🔴 Crítico |
| **Dívida Técnica** | Alta | 🔴 Atenção |

### Problemas Críticos Identificados

| # | Problema | Impacto | Esforço | Arquivos Afetados |
|---|----------|---------|---------|-------------------|
| 1 | 🔴 Chaves de API expostas | Segurança | Baixo | 3 arquivos |
| 2 | 🔴 Sem autenticação | Segurança | Alto | Todo o app |
| 3 | 🔴 Sem regras Firestore | Segurança | Médio | 1 arquivo novo |
| 4 | 🔴 Zero testes | Qualidade | Alto | test/ vazio |
| 5 | 🟠 Violações Clean Arch | Arquitetura | Médio | 8+ arquivos |

### Distribuição de Melhorias

```
🔴 Críticas:    5 itens
🟠 Alta:        11 itens
🟡 Média:       15 itens
🟢 Baixa:       10 itens
───────────────────────
Total:          41 melhorias
```

---

## 1. 🔒 Segurança (CRÍTICO)

### 1.1 Chaves de API Firebase Expostas no Código

**Prioridade**: 🔴 CRÍTICO
**Esforço**: Baixo (2-4h)
**Impacto**: Segurança total do app

#### Problema

As chaves de API do Firebase estão hardcoded em arquivos versionados:

**Arquivos Afetados**:
- `lib/firebase_options.dart:52-67`
- `lib/firebase_options_dev.dart:52-67`
- `lib/firebase_options_prod.dart:52-67`

```dart
// ❌ PROBLEMA
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyChuhcMYmbQY-qV6r_9bKVGvdqZ9k-Wo_s', // EXPOSTA!
  appId: '1:692919346587:android:b01271a8ed906260956d3e',
  messagingSenderId: '692919346587',
  projectId: 'limit-spending',
);
```

#### Por que isso é um problema?

- ✗ Chaves visíveis no repositório Git
- ✗ Qualquer pessoa pode acessar seu Firebase
- ✗ Risco de abuso (quota, custos)
- ✗ Comprometimento dos dados dos usuários

#### Solução Recomendada

**Opção 1: Usar `--dart-define` (Recomendada)**

```bash
# build
flutter build apk \
  --dart-define=FIREBASE_API_KEY=AIza... \
  --dart-define=FIREBASE_APP_ID=1:692...

# run
flutter run \
  --dart-define=FIREBASE_API_KEY=AIza... \
  --dart-define=FIREBASE_APP_ID=1:692...
```

No código:
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: String.fromEnvironment('FIREBASE_API_KEY'),
  appId: String.fromEnvironment('FIREBASE_APP_ID'),
  messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
  projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
);
```

**Opção 2: Usar pacote `flutter_dotenv`**

```yaml
# pubspec.yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

```env
# .env (NÃO versionar!)
FIREBASE_API_KEY=AIza...
FIREBASE_APP_ID=1:692...
```

#### Checklist de Implementação

- [ ] Rotacionar todas as chaves de API no Firebase Console
- [ ] Remover chaves antigas dos arquivos
- [ ] Implementar solução com variáveis de ambiente
- [ ] Atualizar `.gitignore` para incluir `.env*`
- [ ] Atualizar script `switch_env.sh`
- [ ] Documentar processo no README

---

### 1.2 Ausência de Autenticação

**Prioridade**: 🔴 CRÍTICO
**Esforço**: Alto (40-80h)
**Impacto**: Segurança e privacidade dos dados

#### Problema

O aplicativo **não possui sistema de autenticação**. Todos os dados no Firestore são acessíveis a qualquer pessoa com acesso ao Firebase.

#### Por que isso é um problema?

- ✗ Dados de gastos são sensíveis (privacidade)
- ✗ Qualquer pessoa pode ler/modificar qualquer dado
- ✗ Impossível ter múltiplos usuários
- ✗ Sem controle de acesso

#### Solução Recomendada

**Implementar Firebase Authentication**

```yaml
# pubspec.yaml
dependencies:
  firebase_auth: ^5.3.4
```

**Estrutura de Dados com userId**:

```dart
// Firestore
expenses/
  {expenseId}/
    userId: "abc123"      // ← Adicionar!
    description: "..."
    value: 100.0
    categoryId: "..."
```

**Fluxo de Autenticação**:

```dart
// 1. Criar feature de auth
lib/features/auth/
  ├── domain/
  │   ├── entities/user_entity.dart
  │   ├── repositories/auth_repository.dart
  │   └── usecases/
  │       ├── sign_in_usecase.dart
  │       └── sign_out_usecase.dart
  ├── data/
  │   └── repositories/auth_firebase_repository.dart
  └── presentation/
      ├── pages/login_page.dart
      └── controllers/auth_controller.dart

// 2. Proteger main
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final user = FirebaseAuth.instance.currentUser;

  runApp(MyApp(
    initialRoute: user == null ? '/login' : '/home',
  ));
}
```

#### Checklist de Implementação

- [ ] Adicionar `firebase_auth` ao pubspec.yaml
- [ ] Criar feature `auth` com Clean Architecture
- [ ] Implementar login com email/senha
- [ ] Implementar Google Sign-In (opcional)
- [ ] Adicionar `userId` em todas as entidades
- [ ] Atualizar todos os repositórios para filtrar por `userId`
- [ ] Criar tela de login/cadastro
- [ ] Implementar logout
- [ ] Proteger rota principal

---

### 1.3 Regras de Segurança do Firestore Ausentes

**Prioridade**: 🔴 CRÍTICO
**Esforço**: Médio (4-8h)
**Impacto**: Segurança do banco de dados

#### Problema

**Não existe arquivo `firestore.rules`** no projeto. O Firestore está provavelmente em modo de teste (acesso público).

#### Por que isso é um problema?

- ✗ Qualquer pessoa pode ler TODOS os dados
- ✗ Qualquer pessoa pode deletar TODOS os dados
- ✗ Sem validação de dados no servidor
- ✗ Vulnerável a ataques

#### Solução Recomendada

Criar arquivo `firestore.rules`:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helper function
    function isOwner(userId) {
      return request.auth != null && request.auth.uid == userId;
    }

    function isValidExpense() {
      let expense = request.resource.data;
      return expense.value is number &&
             expense.value > 0 &&
             expense.description is string &&
             expense.categoryId is string;
    }

    // Expenses
    match /expenses/{expenseId} {
      allow read: if isOwner(resource.data.userId);
      allow create: if isOwner(request.resource.data.userId) &&
                       isValidExpense();
      allow update: if isOwner(resource.data.userId) &&
                       isValidExpense();
      allow delete: if isOwner(resource.data.userId);
    }

    // Categories
    match /categories/{categoryId} {
      allow read: if isOwner(resource.data.userId);
      allow write: if isOwner(request.resource.data.userId);
    }

    // Payment Methods
    match /payment_methods/{methodId} {
      allow read: if isOwner(resource.data.userId);
      allow write: if isOwner(request.resource.data.userId);
    }

    // Debts
    match /debts/{debtId} {
      allow read: if isOwner(resource.data.userId);
      allow write: if isOwner(request.resource.data.userId);
    }

    // Negar tudo que não foi explicitamente permitido
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

**Deploy das Regras**:

```bash
# Adicionar ao firebase.json
{
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  }
}

# Deploy
firebase deploy --only firestore:rules
```

#### Checklist de Implementação

- [ ] Criar arquivo `firestore.rules`
- [ ] Adicionar regras básicas de segurança
- [ ] Adicionar validações de dados
- [ ] Configurar `firebase.json`
- [ ] Deploy das regras no ambiente dev
- [ ] Testar acesso com/sem autenticação
- [ ] Deploy das regras no ambiente prod
- [ ] Adicionar regras ao switch_env.sh

---

## 2. 🏗️ Arquitetura

### 2.1 Violações da Clean Architecture

**Prioridade**: 🟠 Alta
**Esforço**: Médio (8-16h)
**Impacto**: Manutenibilidade e testabilidade

#### Problema 1: Entidades Dependem de Models

**Arquivo**: `lib/features/expense/domain/entities/expense_entity.dart:24-34`

```dart
// ❌ ERRADO: Domain importando Data
import '../../data/models/expense_model.dart';

class ExpenseEntity extends Equatable {
  // ...

  ExpenseModel toModel() {  // Domain não deveria conhecer Model!
    return ExpenseModel(...);
  }
}
```

**Por que isso é errado?**
- Domain é a camada mais interna (não deve depender de nada)
- Viola o princípio de inversão de dependência
- Impede testar o domínio isoladamente

**Solução**:

```dart
// ✅ CORRETO: Model converte Entity
// lib/features/expense/domain/entities/expense_entity.dart
class ExpenseEntity extends Equatable {
  // Sem método toModel()!
  // Sem imports de data!
}

// lib/features/expense/data/models/expense_model.dart
class ExpenseModel extends ExpenseEntity {
  // ...

  factory ExpenseModel.fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      id: entity.id,
      description: entity.description,
      // ...
    );
  }
}
```

#### Problema 2: Repository Interface usa Model ao invés de Entity

**Arquivo**: `lib/features/expense/domain/repositories/expense_repository.dart:1-2,6-7`

```dart
// ❌ ERRADO
import '../../data/data.dart';  // Domain importando Data!

abstract class ExpenseRepository {
  Future<void> createExpense(ExpenseModel expense);  // Deveria ser Entity!
}
```

**Solução**:

```dart
// ✅ CORRETO
abstract class ExpenseRepository {
  Future<void> createExpense(ExpenseEntity expense);  // Entity!
  // A conversão para Model acontece na implementação (Data layer)
}

// Na implementação:
class ExpenseFirebaseRepository implements ExpenseRepository {
  @override
  Future<void> createExpense(ExpenseEntity expense) async {
    final model = ExpenseModel.fromEntity(expense);  // Conversão aqui!
    await firestore.collection('expenses').doc(model.id).set(model.toJson());
  }
}
```

#### Arquivos que Precisam Ser Corrigidos

| Feature | Entity | Repository | Prioridade |
|---------|--------|------------|------------|
| expense | ✗ | ✗ | 🔴 Alta |
| category | ✗ | ✗ | 🔴 Alta |
| payment_method | ✗ | ✗ | 🔴 Alta |
| debt | ✗ | ✗ | 🔴 Alta |
| supermarket | ? | ? | 🟡 Baixa |

#### Checklist de Implementação

- [ ] Remover método `toModel()` de todas as entidades
- [ ] Atualizar interfaces de repositório para usar Entity
- [ ] Atualizar implementações de repositório
- [ ] Atualizar use cases (já usam Entity corretamente)
- [ ] Rodar `dart analyze` para verificar
- [ ] Executar testes (quando houverem)

---

### 2.2 Inconsistência na Estrutura de Pastas

**Prioridade**: 🟡 Média
**Esforço**: Baixo (1-2h)
**Impacto**: Consistência

#### Problema

Diferentes features usam nomenclaturas diferentes:

| Feature | Pasta Use Cases |
|---------|-----------------|
| expense | `usecases/` ✅ |
| category | `usecases/` ✅ |
| debt | `usecases/` ✅ |
| payment_method | `use_cases/` ❌ |

**Arquivo**: `lib/features/payment_method/domain/use_cases/` vs `usecases/`

#### Solução

Padronizar para `usecases/` (sem underscore):

```bash
cd lib/features/payment_method/domain/
mv use_cases usecases
```

#### Outros problemas de nomenclatura:
- Feature `debt` tem arquivo `debit.dart` (typo)
- `PaymentMethodNotifier` vs outros `*Controller`

---

### 2.3 Factories no Core (Violação de Separação)

**Prioridade**: 🟡 Média
**Esforço**: Médio (4-8h)
**Impacto**: Organização

#### Problema

Todas as factories estão em `/lib/core/factories/`, mas Core deveria conter apenas código **transversal** (shared).

**Arquivos**:
- `lib/core/factories/expense_factory.dart`
- `lib/core/factories/category_factory.dart`
- `lib/core/factories/payment_method_factory.dart`
- etc.

#### Por que isso é um problema?

- Core fica acoplado a todas as features
- Dificulta modularização
- Dificulta remoção de features

#### Solução Recomendada

**Opção 1: Mover factories para as features**

```
lib/features/expense/
  ├── data/
  ├── domain/
  ├── presentation/
  └── expense_factory.dart  ← Aqui!
```

**Opção 2: Usar injeção de dependências (GetIt)**

```yaml
dependencies:
  get_it: ^8.0.2
```

```dart
// lib/core/di/injection_container.dart
final sl = GetIt.instance;

Future<void> init() async {
  // Repositories
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseFirebaseRepository(firestore: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => CreateExpenseUseCase(sl()));

  // Controllers
  sl.registerFactory(() => ExpenseController(
    createExpenseUseCase: sl(),
    getExpensesUseCase: sl(),
  ));
}

// main.dart
void main() async {
  await init();
  runApp(MyApp());
}

// Uso
final controller = sl<ExpenseController>();
```

#### Checklist

- [ ] Escolher abordagem (factories nas features ou GetIt)
- [ ] Implementar solução escolhida
- [ ] Migrar todas as factories
- [ ] Remover `/core/factories/`
- [ ] Atualizar factories de pages

---

## 3. 💎 Qualidade de Código

### 3.1 Código Duplicado Significativo

**Prioridade**: 🟠 Alta
**Esforço**: Médio (4-8h)
**Impacto**: Manutenibilidade

#### Problema: Tratamento de Erros Repetido

**Todos os repositórios Firebase** têm blocos try-catch idênticos:

```dart
// ❌ Repetido em 5+ arquivos
try {
  // operação Firebase
} on FirebaseException catch (e) {
  final exception = AppExceptionUtils.handleFirebaseError(e);
  LoggerService.error('deleteExpense', exception.message);
  throw exception;
} catch (e, s) {
  LoggerService.error('createExpense', e, s);
  rethrow;
}
```

**Arquivos Afetados**:
- `lib/features/expense/data/repositories/expense_firebase_repository.dart`
- `lib/features/debt/data/firebase_debt_repository.dart`
- `lib/features/category/data/repositories/category_firebase_repository.dart`
- `lib/features/payment_method/data/repositories/payment_method_firebase_repository.dart`

#### Solução: Criar Mixin ou Classe Base

**Opção 1: Mixin (Recomendada)**

```dart
// lib/core/data/firebase_error_handler_mixin.dart
mixin FirebaseErrorHandlerMixin {
  Future<T> handleFirebaseOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    try {
      return await operation();
    } on FirebaseException catch (e) {
      final exception = AppExceptionUtils.handleFirebaseError(e);
      LoggerService.error(operationName, exception.message);
      throw exception;
    } catch (e, s) {
      LoggerService.error(operationName, e, s);
      rethrow;
    }
  }
}

// Uso:
class ExpenseFirebaseRepository
    with FirebaseErrorHandlerMixin
    implements ExpenseRepository {

  @override
  Future<void> createExpense(ExpenseEntity expense) {
    return handleFirebaseOperation(
      'createExpense',
      () async {
        final model = ExpenseModel.fromEntity(expense);
        await firestore.collection('expenses').add(model.toJson());
      },
    );
  }
}
```

**Opção 2: Classe Base Abstrata**

```dart
// lib/core/data/base_firebase_repository.dart
abstract class BaseFirebaseRepository {
  final FirebaseFirestore firestore;

  BaseFirebaseRepository(this.firestore);

  Future<T> executeFirebaseOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    try {
      return await operation();
    } on FirebaseException catch (e) {
      final exception = AppExceptionUtils.handleFirebaseError(e);
      LoggerService.error(operationName, exception.message);
      throw exception;
    } catch (e, s) {
      LoggerService.error(operationName, e, s);
      rethrow;
    }
  }
}

// Uso:
class ExpenseFirebaseRepository
    extends BaseFirebaseRepository
    implements ExpenseRepository {

  ExpenseFirebaseRepository(super.firestore);

  @override
  Future<void> createExpense(ExpenseEntity expense) {
    return executeFirebaseOperation('createExpense', () async {
      final model = ExpenseModel.fromEntity(expense);
      await firestore.collection('expenses').add(model.toJson());
    });
  }
}
```

#### Checklist

- [ ] Criar mixin ou classe base
- [ ] Refatorar ExpenseFirebaseRepository
- [ ] Refatorar CategoryFirebaseRepository
- [ ] Refatorar PaymentMethodFirebaseRepository
- [ ] Refatorar DebtFirebaseRepository
- [ ] Remover código duplicado
- [ ] Verificar se não quebrou nada

---

### 3.2 Logs com Nomes de Métodos Incorretos

**Prioridade**: 🟠 Alta
**Esforço**: Baixo (1h)
**Impacto**: Debugging

#### Problema

Copy-paste de código resultou em logs com nomes errados:

**Arquivo**: `lib/features/debt/data/firebase_debt_repository.dart`

```dart
Future<Failure?> addDebtValue(...) async {
  try {
    // ...
  } on FirebaseException catch (e) {
    LoggerService.error('deleteExpense', ...);  // ❌ Nome errado!
  } catch (e, s) {
    LoggerService.error('createExpense', e, s);  // ❌ Nome errado!
  }
}
```

**Linhas afetadas**:
- Linha 24: `deleteExpense` deveria ser `addDebtValue`
- Linha 27: `createExpense` deveria ser `addDebtValue`
- Linhas 47, 50: Mesmos erros em `getDebts`

#### Solução

Após implementar o mixin/classe base (item 3.1), esse problema será automaticamente resolvido, pois o nome da operação será passado como parâmetro.

Se não implementar o mixin:

```dart
// ✅ Correto
Future<Failure?> addDebtValue(...) async {
  try {
    // ...
  } on FirebaseException catch (e) {
    LoggerService.error('addDebtValue', ...);  // Nome correto!
  }
}
```

#### Checklist

- [ ] Buscar todos os `LoggerService.error`
- [ ] Verificar se o nome do método está correto
- [ ] Corrigir nomes incorretos

---

### 3.3 Código Comentado/Morto

**Prioridade**: 🟡 Média
**Esforço**: Baixo (30min)
**Impacto**: Limpeza

#### Problema

Código comentado nunca deveria estar em produção (para isso existe Git).

**Arquivo 1**: `lib/features/supermarket/presentation/supermarket_page.dart:155-189`
```dart
// Mais de 30 linhas de código comentado:
// Widget _buildFilter() {
//   return Row(
//     children: [
//       Expanded(
//         child: TextFormField(
// ...
```

**Arquivo 2**: `lib/main.dart:25`
```dart
MaterialApp(
  // ...
  // home: supermarketPageFactory(),  // ← Desnecessário
  home: supermarketPageFactory(),
);
```

#### Solução

Deletar todo código comentado. Se precisar recuperar, use `git log`.

```bash
# Buscar código comentado
grep -rn "^[[:space:]]*//.*Widget\|^[[:space:]]*//.*void\|^[[:space:]]*//.*class" lib/
```

#### Checklist

- [ ] Remover código comentado de `supermarket_page.dart`
- [ ] Remover linha comentada de `main.dart`
- [ ] Buscar outros arquivos com código comentado
- [ ] Criar pre-commit hook para prevenir

---

### 3.4 Variável Mutável em StatelessWidget (BUG)

**Prioridade**: 🔴 Alta
**Esforço**: Baixo (2h)
**Impacto**: Corretude

#### Problema

`StatelessWidget` não deve ter estado mutável, mas há variáveis sendo modificadas:

**Arquivo 1**: `lib/features/category/presentation/category_page.dart:21`

```dart
class CategoryPage extends StatelessWidget {
  bool actionExecuted = false;  // ❌ ERRADO!

  // Depois é modificado:
  actionExecuted = true;  // Não vai funcionar como esperado!
}
```

**Arquivo 2**: `lib/features/payment_method/presentation/payment_method_page.dart:13-14`

```dart
class PaymentMethodPage extends StatelessWidget {
  bool actionExecuted = false;  // ❌ ERRADO!
}
```

#### Por que isso é um problema?

- StatelessWidget pode ser reconstruído múltiplas vezes
- A variável não será resetada entre rebuilds
- Comportamento imprevisível
- Viola o contrato de StatelessWidget

#### Solução

**Opção 1: Converter para StatefulWidget**

```dart
class CategoryPage extends StatefulWidget {
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool actionExecuted = false;  // ✅ Agora está correto!

  // ...
}
```

**Opção 2: Mover para o Controller**

```dart
class CategoryController {
  bool actionExecuted = false;  // ✅ Estado no controller

  void executeAction() {
    if (actionExecuted) return;
    actionExecuted = true;
    // ...
  }
}
```

#### Checklist

- [ ] Corrigir CategoryPage
- [ ] Corrigir PaymentMethodPage
- [ ] Buscar outros StatelessWidget com variáveis mutáveis
- [ ] Adicionar lint rule: `avoid_non_const_call_to_literal_constructor`

---

### 3.5 Inconsistência de Nomenclatura

**Prioridade**: 🟡 Média
**Esforço**: Baixo (2h)
**Impacto**: Consistência

#### Problemas Identificados

1. **Typo no nome do arquivo**
   - `lib/features/debt/debit.dart` ← deveria ser `debt.dart`

2. **Controllers vs Notifiers**
   - `ExpenseController` ✅
   - `CategoryController` ✅
   - `DebtController` ✅
   - `PaymentMethodNotifier` ❌
   - `SupermarketController` ✅

3. **Composição vs Herança**
   ```dart
   // Maioria usa composição:
   class ExpenseController {
     ValueNotifier<ExpenseState> state = ...;
   }

   // Alguns usam herança:
   class SupermarketController extends ValueNotifier<SupermarketState> {
     // ...
   }
   ```

#### Solução

Padronizar tudo para:
- Sufixo `Controller` (não `Notifier`)
- Usar **composição** (não herança)

```dart
// ✅ Padrão
class PaymentMethodController {
  ValueNotifier<PaymentMethodState> state = ValueNotifier(...);
}
```

#### Checklist

- [ ] Renomear `debit.dart` para `debt.dart`
- [ ] Renomear `PaymentMethodNotifier` para `PaymentMethodController`
- [ ] Refatorar `SupermarketController` para usar composição
- [ ] Atualizar todos os imports
- [ ] Atualizar factories

---

## 4. ⚡ Performance

### 4.1 Novas Instâncias de Repositórios a Cada Operação

**Prioridade**: 🟠 Alta
**Esforço**: Médio (4h se usar GetIt)
**Impacto**: Performance e memória

#### Problema

Factories criam novas instâncias toda vez que são chamadas:

```dart
// ❌ PROBLEMA
ExpenseRepository makeExpenseRepository() => ExpenseFirebaseRepository(
  firestore: makeFirestoreFactory(),
);

CreateExpenseUseCase makeCreateExpenseUseCase() {
  return CreateExpenseUseCase(
    expenseRepository: makeExpenseRepository(),  // Nova instância!
  );
}

// Cada vez que um use case é criado, cria um novo repositório!
```

#### Por que isso é um problema?

- Cria múltiplas instâncias desnecessárias
- Desperdiça memória
- Não reutiliza conexões

#### Solução

**Opção 1: Singleton Manual**

```dart
// lib/core/factories/singletons.dart
class _Singletons {
  static FirebaseFirestore? _firestore;
  static ExpenseRepository? _expenseRepository;

  static FirebaseFirestore get firestore {
    return _firestore ??= FirebaseFirestore.instance;
  }

  static ExpenseRepository get expenseRepository {
    return _expenseRepository ??= ExpenseFirebaseRepository(
      firestore: firestore,
    );
  }
}

ExpenseRepository makeExpenseRepository() => _Singletons.expenseRepository;
```

**Opção 2: GetIt (Recomendada)**

```dart
final sl = GetIt.instance;

void init() {
  // Singleton - mesma instância sempre
  sl.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseFirebaseRepository(firestore: sl()),
  );

  // Factory - nova instância toda vez (para controllers)
  sl.registerFactory(() => ExpenseController(
    createExpenseUseCase: sl(),
  ));
}
```

---

### 4.2 Queries Firestore Sem Paginação

**Prioridade**: 🟠 Alta
**Esforço**: Médio (8-16h)
**Impacto**: Performance e escalabilidade

#### Problema

Todas as queries buscam **todos** os documentos de uma vez:

**Arquivo**: `lib/features/expense/data/repositories/expense_firebase_repository.dart:50-72`

```dart
Future<List<ExpenseEntity>> getExpenses({required String categoryId}) async {
  final snapshot = await firestore
    .collection('expenses')
    .where('categoryId', isEqualTo: categoryId)
    .get();  // ❌ Busca TUDO de uma vez!

  return snapshot.docs.map((doc) => ExpenseModel.fromJson(doc.data())).toList();
}
```

#### Por que isso é um problema?

- Usuário com 1000 despesas = app trava
- Alto consumo de memória
- Alto custo de reads no Firebase
- Experiência ruim (loading longo)

#### Solução: Implementar Paginação

```dart
// Entity
class PaginatedExpenses {
  final List<ExpenseEntity> expenses;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  PaginatedExpenses({
    required this.expenses,
    this.lastDocument,
    required this.hasMore,
  });
}

// Repository
abstract class ExpenseRepository {
  Future<PaginatedExpenses> getExpensesPaginated({
    required String categoryId,
    DocumentSnapshot? startAfter,
    int limit = 20,
  });
}

// Implementação
class ExpenseFirebaseRepository implements ExpenseRepository {
  @override
  Future<PaginatedExpenses> getExpensesPaginated({
    required String categoryId,
    DocumentSnapshot? startAfter,
    int limit = 20,
  }) async {
    Query query = firestore
        .collection('expenses')
        .where('categoryId', isEqualTo: categoryId)
        .orderBy('date', descending: true)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();
    final expenses = snapshot.docs
        .map((doc) => ExpenseModel.fromJson(doc.data()))
        .toList();

    return PaginatedExpenses(
      expenses: expenses,
      lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      hasMore: snapshot.docs.length == limit,
    );
  }
}

// Controller
class ExpenseController {
  DocumentSnapshot? _lastDocument;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;

    final result = await getExpensesPaginatedUseCase(
      categoryId: selectedCategory,
      startAfter: _lastDocument,
    );

    _lastDocument = result.lastDocument;
    _hasMore = result.hasMore;

    state.value = state.value.copyWith(
      expenses: [...state.value.expenses, ...result.expenses],
    );

    _isLoadingMore = false;
  }
}

// UI
ListView.builder(
  controller: _scrollController,
  itemCount: expenses.length + (_hasMore ? 1 : 0),
  itemBuilder: (context, index) {
    if (index == expenses.length) {
      // Trigger load more
      controller.loadMore();
      return CircularProgressIndicator();
    }
    return ExpenseItem(expense: expenses[index]);
  },
);
```

#### Checklist

- [ ] Implementar paginação em `ExpenseRepository`
- [ ] Implementar em `CategoryRepository`
- [ ] Implementar em `PaymentMethodRepository`
- [ ] Implementar em `DebtRepository`
- [ ] Atualizar use cases
- [ ] Atualizar controllers
- [ ] Atualizar UI com scroll infinito
- [ ] Adicionar pull-to-refresh

---

### 4.3 Queries Sequenciais que Poderiam Ser Paralelas

**Prioridade**: 🟡 Média
**Esforço**: Baixo (2h)
**Impacto**: Performance

#### Problema

Queries independentes são executadas sequencialmente:

**Arquivo**: `lib/features/debt/presentation/debt_controller.dart:31-45`

```dart
Future<void> load() async {
  state.value = state.value.copyWith(status: DebtStatus.loading);

  // ❌ Sequencial - 2x mais lento!
  final (failureDebt, debts) = await getDebtsUseCase();
  final (failureCard, cards) = await getCardPaymentMethodsUseCase();

  // ...
}
```

Se cada query leva 500ms, o total é **1000ms** ao invés de **500ms**.

#### Solução: Usar `Future.wait`

```dart
Future<void> load() async {
  state.value = state.value.copyWith(status: DebtStatus.loading);

  // ✅ Paralelo - 2x mais rápido!
  final results = await Future.wait([
    getDebtsUseCase(),
    getCardPaymentMethodsUseCase(),
  ]);

  final (failureDebt, debts) = results[0];
  final (failureCard, cards) = results[1];

  // Tratar erros...
}
```

**Ou com nomes explícitos**:

```dart
final [
  (failureDebt, debts),
  (failureCard, cards),
] = await Future.wait([
  getDebtsUseCase(),
  getCardPaymentMethodsUseCase(),
]);
```

#### Arquivos para Corrigir

- `lib/features/debt/presentation/debt_controller.dart:31-45`
- Verificar outros controllers com múltiplas queries

---

### 4.4 Cálculos Locais que Poderiam Ser Agregações

**Prioridade**: 🟢 Baixa
**Esforço**: Alto (16-24h - requer Cloud Functions)
**Impacto**: Performance e custo

#### Problema

Método busca **todos** os documentos e calcula a soma localmente:

**Arquivo**: `lib/features/expense/data/repositories/expense_firebase_repository.dart:136-163`

```dart
Future<(Failure?, double?)> getExpensesSumByPeriodCreated({...}) async {
  final snapshot = await firestore
      .collection('expenses')
      .where('categoryId', isEqualTo: categoryId)
      .get();  // Busca TUDO

  // Calcula soma localmente ❌
  double sum = 0;
  for (var doc in snapshot.docs) {
    final expense = ExpenseModel.fromJson(doc.data());
    if (expense.createdDate.isAfter(startDate) &&
        expense.createdDate.isBefore(endDate)) {
      sum += expense.value;
    }
  }
  return (null, sum);
}
```

#### Por que isso é um problema?

- Lê todos os documentos (custo alto)
- Transfere muito dado pela rede
- Processamento no cliente

#### Solução: Cloud Functions + Agregações

**Opção 1: Cloud Function**

```javascript
// functions/index.js
exports.getExpenseSum = functions.https.onCall(async (data, context) => {
  const { categoryId, startDate, endDate, userId } = data;

  const snapshot = await admin.firestore()
    .collection('expenses')
    .where('userId', '==', userId)
    .where('categoryId', '==', categoryId)
    .where('date', '>=', startDate)
    .where('date', '<=', endDate)
    .get();

  const sum = snapshot.docs.reduce((acc, doc) => acc + doc.data().value, 0);

  return { sum };
});
```

**Opção 2: Firestore Aggregation Queries (mais simples)**

```dart
Future<double> getExpenseSum({...}) async {
  final query = firestore
      .collection('expenses')
      .where('categoryId', isEqualTo: categoryId)
      .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
      .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));

  final aggregateQuery = query.aggregate(sum('value'));
  final snapshot = await aggregateQuery.get();

  return snapshot.get('sum') as double? ?? 0.0;
}
```

**Opção 3: Cache de Agregações**

Manter documento separado com agregações:

```dart
// Estrutura
aggregations/
  {userId}/
    expenses_summary/
      {categoryId}/
        month_2025_12: { sum: 1500.0, count: 25 }
        month_2025_11: { sum: 1200.0, count: 20 }
```

---

## 5. 🧪 Testes

### 5.1 Cobertura de Testes: 0%

**Prioridade**: 🔴 Crítico (para produção)
**Esforço**: Alto (40-80h)
**Impacto**: Qualidade e confiabilidade

#### Problema

O diretório `/test` está **vazio**. Não há:
- Testes unitários
- Testes de widget
- Testes de integração

#### Por que isso é crítico?

- Impossível refatorar com segurança
- Bugs passam despercebidos
- Regressões não detectadas
- Baixa confiança no código

#### Solução: Implementar Estrutura de Testes

```
test/
├── unit/
│   ├── core/
│   │   ├── extensions/
│   │   │   └── double_extensions_test.dart
│   │   └── exceptions/
│   │       └── app_exception_test.dart
│   └── features/
│       └── expense/
│           ├── domain/
│           │   └── usecases/
│           │       ├── create_expense_usecase_test.dart
│           │       ├── get_expenses_usecase_test.dart
│           │       └── delete_expense_usecase_test.dart
│           ├── data/
│           │   ├── models/
│           │   │   └── expense_model_test.dart
│           │   └── repositories/
│           │       └── expense_firebase_repository_test.dart
│           └── presentation/
│               └── controllers/
│                   └── expense_controller_test.dart
├── widget/
│   └── features/
│       └── expense/
│           └── expense_page_test.dart
├── integration/
│   └── expense_flow_test.dart
└── helpers/
    ├── mock_firestore.dart
    └── test_factories.dart
```

### 5.2 Adicionar Dependências de Teste

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.4              # Mocking (melhor que mockito)
  fake_cloud_firestore: ^3.1.0  # Mock do Firestore
  bloc_test: ^9.1.7             # Se usar Bloc
```

### 5.3 Exemplo de Teste Unitário (Use Case)

```dart
// test/unit/features/expense/domain/usecases/create_expense_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late CreateExpenseUseCase useCase;
  late MockExpenseRepository mockRepository;

  setUp(() {
    mockRepository = MockExpenseRepository();
    useCase = CreateExpenseUseCase(expenseRepository: mockRepository);
  });

  group('CreateExpenseUseCase', () {
    final testExpense = ExpenseEntity(
      id: '1',
      description: 'Test',
      value: 100.0,
      date: DateTime.now(),
      categoryId: 'cat1',
    );

    test('should create expense successfully', () async {
      // Arrange
      when(() => mockRepository.createExpense(any()))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await useCase(testExpense);

      // Assert
      expect(result, null);
      verify(() => mockRepository.createExpense(any())).called(1);
    });

    test('should return Failure when repository throws exception', () async {
      // Arrange
      when(() => mockRepository.createExpense(any()))
          .thenThrow(NetworkErrorException());

      // Act
      final result = await useCase(testExpense);

      // Assert
      expect(result, isA<Failure>());
      expect(result!.message, contains('conexão'));
    });
  });
}
```

### 5.4 Exemplo de Teste de Widget

```dart
// test/widget/features/expense/expense_page_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  late ExpenseController mockController;

  setUp(() {
    mockController = MockExpenseController();
  });

  testWidgets('should display loading indicator when loading', (tester) async {
    // Arrange
    mockController.state.value = ExpenseState(status: ExpenseStatus.loading);

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ExpensePage(controller: mockController),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display expenses when loaded', (tester) async {
    // Arrange
    final expenses = [
      ExpenseEntity(id: '1', description: 'Test', value: 100, ...),
    ];
    mockController.state.value = ExpenseState(
      status: ExpenseStatus.success,
      expenses: expenses,
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(home: ExpensePage(controller: mockController)),
    );

    // Assert
    expect(find.text('Test'), findsOneWidget);
    expect(find.text('R\$ 100,00'), findsOneWidget);
  });
}
```

### 5.5 Prioridade de Testes

| Tipo | Prioridade | Esforço | Ordem |
|------|------------|---------|-------|
| Use Cases | 🔴 Alta | Médio | 1º |
| Controllers | 🔴 Alta | Médio | 2º |
| Models | 🟠 Média | Baixo | 3º |
| Extensions | 🟡 Baixa | Baixo | 4º |
| Widgets | 🟡 Baixa | Alto | 5º |
| Integração | 🟢 Baixa | Alto | 6º |

#### Checklist

- [ ] Adicionar dependências de teste
- [ ] Criar estrutura de pastas
- [ ] Criar helpers (mocks, factories)
- [ ] Escrever testes para use cases críticos
- [ ] Escrever testes para controllers
- [ ] Configurar CI para rodar testes
- [ ] Meta: 80% de cobertura

---

## 6. 🎨 UX/UI

### 6.1 Estados de Loading Inconsistentes

**Prioridade**: 🟡 Média
**Esforço**: Baixo (2-4h)
**Impacto**: Experiência do usuário

#### Problema

Tratamento inconsistente de estados de loading nas pages.

**Alguns mostram**:
```dart
ExpenseStatus.loading => Center(child: CircularProgressIndicator())
```

**Outros não tratam adequadamente** o estado inicial vs loading.

#### Solução

Criar widget compartilhado:

```dart
// lib/core/widgets/loading_state_builder.dart
class LoadingStateBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<T> snapshot;
  final Widget Function(T data) builder;
  final Widget? onLoading;
  final Widget Function(Object error)? onError;

  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return onLoading ?? Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return onError?.call(snapshot.error!) ??
             ErrorWidget(error: snapshot.error!);
    }

    if (snapshot.hasData) {
      return builder(snapshot.data!);
    }

    return SizedBox.shrink();
  }
}
```

Ou usar package `flutter_bloc` com `BlocBuilder`:

```dart
BlocBuilder<ExpenseBloc, ExpenseState>(
  builder: (context, state) {
    return switch (state.status) {
      ExpenseStatus.loading => LoadingWidget(),
      ExpenseStatus.error => ErrorWidget(state.error),
      ExpenseStatus.success => ExpenseList(state.expenses),
      _ => SizedBox.shrink(),
    };
  },
);
```

### 6.2 Operações sem `await` (Bug)

**Prioridade**: 🔴 Alta
**Esforço**: Baixo (1h)
**Impacto**: Bugs e comportamento inesperado

#### Problema

Operações assíncronas não aguardam conclusão:

**Arquivo**: `lib/features/payment_method/presentation/payment_method_notifier.dart:121-149`

```dart
void submit() {
  if (isEditing) {
    updatePaymentMethodUseCase(paymentMethod);  // ❌ Sem await!
  } else {
    createPaymentMethodUseCase(paymentMethod);  // ❌ Sem await!
  }
  load();  // ❌ Pode executar antes das operações terminarem!
}
```

**Resultado**: `load()` pode executar **antes** do create/update terminar, mostrando dados antigos.

#### Solução

```dart
Future<void> submit() async {  // ← async
  try {
    if (isEditing) {
      await updatePaymentMethodUseCase(paymentMethod);  // ← await
    } else {
      await createPaymentMethodUseCase(paymentMethod);  // ← await
    }
    await load();  // ← await

    // Feedback de sucesso
    // showSuccessSnackBar();
  } catch (e) {
    // Tratar erro
  }
}
```

#### Checklist

- [ ] Buscar todos os métodos sem `await`
- [ ] Adicionar `await` onde necessário
- [ ] Adicionar feedback de sucesso/erro
- [ ] Testar fluxo completo

### 6.3 SnackBar Duplicado

**Prioridade**: 🟢 Baixa
**Esforço**: Baixo (30min)
**Impacto**: Limpeza

#### Problema

Duas chamadas para mostrar SnackBar:

**Arquivo**: `lib/features/expense/presentation/expense_page.dart:18-33`

```dart
void showMessage(String message, bool isError) {
  SnackBarCustom(context: context, message: message, isError: isError);  // 1

  ScaffoldMessenger.of(context).showSnackBar(  // 2 - Duplicado!
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
    ),
  );
}
```

#### Solução

Remover uma das chamadas:

```dart
void showMessage(String message, bool isError) {
  SnackBarCustom(context: context, message: message, isError: isError);
  // Remover a segunda chamada
}
```

Ou usar apenas a segunda se `SnackBarCustom` também chama `showSnackBar`.

### 6.4 Acessibilidade

**Prioridade**: 🟡 Média
**Esforço**: Médio (8-16h)
**Impacto**: Inclusão

#### Problemas

- Falta `Semantics` widgets
- Sem suporte a leitores de tela
- Contraste pode ser insuficiente
- Sem hint text em campos de formulário

#### Solução

```dart
// Adicionar Semantics
Semantics(
  label: 'Valor da despesa',
  child: TextFormField(
    decoration: InputDecoration(
      labelText: 'Valor',
      hintText: 'Digite o valor',  // ← Adicionar hints
    ),
  ),
);

// Botões com label
Semantics(
  label: 'Deletar despesa',
  button: true,
  child: IconButton(
    icon: Icon(Icons.delete),
    onPressed: () => deleteExpense(),
  ),
);

// Verificar contraste
// Use ferramentas como "Accessibility Scanner" no Android
```

#### Checklist

- [ ] Adicionar Semantics em widgets interativos
- [ ] Adicionar hint text em formulários
- [ ] Testar com TalkBack (Android) / VoiceOver (iOS)
- [ ] Verificar contraste de cores
- [ ] Testar navegação por teclado

---

## 7. ⚙️ Configurações

### 7.1 Atualizar `analysis_options.yaml`

**Prioridade**: 🟠 Alta
**Esforço**: Baixo (1h)
**Impacto**: Qualidade de código

#### Problema 1: Ignorar `must_be_immutable` é Perigoso

```yaml
analyzer:
  errors:
    must_be_immutable: ignore  # ❌ NÃO RECOMENDADO
```

Essa regra previne bugs como o encontrado em `CategoryPage` (StatelessWidget com variável mutável).

#### Solução

```yaml
analyzer:
  errors:
    # Remover essa linha ou usar:
    must_be_immutable: warning  # Aviso ao invés de erro
  exclude:
    - build/**
    - '**/*.g.dart'
    - '**/*.freezed.dart'
  language:
    strict-casts: true
    strict-raw-types: true
```

#### Problema 2: Regras de Lint Faltando

Adicionar regras importantes:

```yaml
linter:
  rules:
    # Existentes
    - always_declare_return_types
    - cancel_subscriptions
    - close_sinks
    - require_trailing_commas
    - prefer_relative_imports

    # ADICIONAR:

    # Performance
    - avoid_unnecessary_containers
    - sized_box_for_whitespace
    - sized_box_shrink_expand
    - use_build_context_synchronously

    # Segurança
    - avoid_print  # Importante para produção!
    - avoid_web_libraries_in_flutter

    # Legibilidade
    - prefer_const_constructors
    - prefer_const_constructors_in_immutables
    - prefer_const_declarations
    - prefer_const_literals_to_create_immutables
    - prefer_final_locals
    - prefer_final_in_for_each
    - prefer_single_quotes
    - sort_child_properties_last

    # Null Safety
    - avoid_null_checks_in_equality_operators
    - null_closures

    # Flutter Específico
    - use_key_in_widget_constructors
    - avoid_redundant_argument_values
    - use_full_hex_values_for_flutter_colors

    # Erros Comuns
    - always_use_package_imports  # Evitar imports relativos de packages
    - avoid_empty_else
    - avoid_returning_null_for_void
    - no_duplicate_case_values
    - unrelated_type_equality_checks
```

### 7.2 Adicionar Permissões no AndroidManifest.xml

**Prioridade**: 🟠 Alta
**Esforço**: Baixo (15min)
**Impacto**: Funcionalidade

#### Problema

Permissões de Internet podem estar faltando:

**Arquivo**: `android/app/src/main/AndroidManifest.xml`

#### Solução

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- Adicionar essas permissões -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

    <application
        android:label="Limit Spending"  <!-- Nome amigável -->
        android:icon="@mipmap/ic_launcher"
        ...>
        ...
    </application>
</manifest>
```

### 7.3 Configurar `.firebaserc` com Ambientes

**Prioridade**: 🟡 Média
**Esforço**: Baixo (15min)
**Impacto**: Organização

#### Problema Atual

```json
{
  "projects": {
    "default": "limit-spending"
  }
}
```

#### Solução

```json
{
  "projects": {
    "default": "limit-spending",
    "dev": "limit-spending-dev",
    "prod": "limit-spending"
  }
}
```

Uso:

```bash
# Selecionar ambiente
firebase use dev
firebase use prod

# Deploy para ambiente específico
firebase deploy --only firestore:rules --project dev
```

### 7.4 Adicionar Dependências Úteis

**Prioridade**: 🟡 Média
**Esforço**: Variável
**Impacto**: Produtividade

#### Dependências Recomendadas

```yaml
dependencies:
  # Estado e DI
  get_it: ^8.0.2                     # Service locator
  # ou
  riverpod: ^2.6.1                   # Gerenciamento de estado

  # Firebase
  firebase_auth: ^5.3.4              # Autenticação
  firebase_crashlytics: ^4.3.1       # Crash reporting
  firebase_analytics: ^11.5.0        # Analytics

  # Storage Local
  shared_preferences: ^2.3.4         # Preferências
  hive: ^2.2.3                       # Cache local

  # UI/UX
  flutter_screenutil: ^5.9.3         # Responsividade
  shimmer: ^3.0.0                    # Loading placeholder
  cached_network_image: ^3.4.1       # Cache de imagens

  # Utilitários
  logger: ^2.4.0                     # Logging melhorado
  connectivity_plus: ^6.1.1          # Status de conexão

dev_dependencies:
  # Testes
  mocktail: ^1.0.4                   # Mocking
  fake_cloud_firestore: ^3.1.0       # Mock Firestore

  # Geração de Código
  build_runner: ^2.4.13              # Para codegen
  json_serializable: ^6.9.2          # Se usar serialização
```

---

## 8. 🚀 CI/CD e Automação

### 8.1 Criar GitHub Actions

**Prioridade**: 🟠 Alta
**Esforço**: Médio (4-8h)
**Impacto**: Qualidade e automação

#### Problema

Não existe pasta `.github/workflows/` - sem CI/CD.

#### Solução

**Arquivo 1**: `.github/workflows/flutter_ci.yaml`

```yaml
name: Flutter CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v4

    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.27.0'
        channel: 'stable'

    - name: Install dependencies
      run: flutter pub get

    - name: Verify formatting
      run: flutter format --set-exit-if-changed .

    - name: Analyze code
      run: flutter analyze

    - name: Run tests
      run: flutter test --coverage

    - name: Upload coverage
      uses: codecov/codecov-action@v4
      with:
        files: ./coverage/lcov.info

  build-android:
    needs: test
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v4

    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.27.0'

    - name: Install dependencies
      run: flutter pub get

    - name: Build APK
      run: flutter build apk --release

    - name: Upload APK
      uses: actions/upload-artifact@v4
      with:
        name: app-release.apk
        path: build/app/outputs/flutter-apk/app-release.apk
```

**Arquivo 2**: `.github/workflows/code_quality.yaml`

```yaml
name: Code Quality

on: [push, pull_request]

jobs:
  quality:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v4

    - uses: subosito/flutter-action@v2

    - name: Check for TODOs
      run: |
        if grep -r "TODO" lib/ test/; then
          echo "TODOs found in code"
          exit 1
        fi

    - name: Check for print statements
      run: |
        if grep -r "print(" lib/; then
          echo "print() found - use Logger instead"
          exit 1
        fi
```

### 8.2 Criar Makefile

**Prioridade**: 🟡 Média
**Esforço**: Baixo (1h)
**Impacto**: Produtividade

#### Solução

**Arquivo**: `Makefile`

```makefile
.PHONY: help run-dev run-prod build-dev build-prod test analyze clean

help: ## Mostra este help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

run-dev: ## Roda app em modo dev
	./switch_env.sh dev && fvm flutter run

run-prod: ## Roda app em modo prod
	./switch_env.sh prod && fvm flutter run --release

build-apk-dev: ## Build APK dev
	./switch_env.sh dev && fvm flutter build apk

build-apk-prod: ## Build APK prod
	./switch_env.sh prod && fvm flutter build apk --release

build-appbundle: ## Build App Bundle
	./switch_env.sh prod && fvm flutter build appbundle --release

test: ## Roda todos os testes
	fvm flutter test

test-coverage: ## Roda testes com coverage
	fvm flutter test --coverage && genhtml coverage/lcov.info -o coverage/html

analyze: ## Analisa código
	fvm dart analyze

format: ## Formata código
	fvm dart format lib/ test/

format-check: ## Verifica formatação
	fvm dart format --set-exit-if-changed lib/ test/

clean: ## Limpa build
	fvm flutter clean
	cd ios && pod deintegrate || true
	cd ios && pod install || true

get: ## Instala dependências
	fvm flutter pub get

upgrade: ## Atualiza dependências
	fvm flutter pub upgrade

outdated: ## Mostra dependências desatualizadas
	fvm flutter pub outdated

deploy-dev: ## Deploy Firebase dev
	./switch_env.sh dev && firebase deploy --only firestore:rules

deploy-prod: ## Deploy Firebase prod
	./switch_env.sh prod && firebase deploy --only firestore:rules
```

Uso:

```bash
make help          # Ver comandos disponíveis
make run-dev       # Rodar em dev
make test          # Rodar testes
make build-apk-prod # Build para produção
```

### 8.3 Configurar Pre-commit Hooks

**Prioridade**: 🟡 Média
**Esforço**: Baixo (2h)
**Impacto**: Qualidade

#### Opção 1: Git Hooks Manual

**Arquivo**: `.git/hooks/pre-commit`

```bash
#!/bin/bash

echo "🔍 Running pre-commit checks..."

# Formatar código
echo "📝 Formatting code..."
fvm dart format lib/ test/

# Analisar código
echo "🔬 Analyzing code..."
if ! fvm dart analyze; then
  echo "❌ Analysis failed. Fix errors before committing."
  exit 1
fi

# Rodar testes
echo "🧪 Running tests..."
if ! fvm flutter test; then
  echo "❌ Tests failed. Fix tests before committing."
  exit 1
fi

echo "✅ All checks passed!"
```

Tornar executável:

```bash
chmod +x .git/hooks/pre-commit
```

#### Opção 2: Lefthook (Recomendado)

```bash
# Instalar lefthook
brew install lefthook  # macOS
# ou
go install github.com/evilmartians/lefthook@latest
```

**Arquivo**: `lefthook.yml`

```yaml
pre-commit:
  parallel: true
  commands:
    format:
      run: fvm dart format lib/ test/
    analyze:
      run: fvm dart analyze
      fail_text: "Code analysis failed"
    tests:
      run: fvm flutter test
      fail_text: "Tests failed"

pre-push:
  commands:
    coverage:
      run: fvm flutter test --coverage
```

Instalar:

```bash
lefthook install
```

---

## 9. 📋 Roadmap de Implementação

### Fase 1: Segurança (URGENTE - 1-2 semanas)

| Item | Prioridade | Esforço | Responsável |
|------|------------|---------|-------------|
| 1.1 Rotacionar chaves API | 🔴 | 2h | - |
| 1.2 Implementar autenticação | 🔴 | 40h | - |
| 1.3 Criar regras Firestore | 🔴 | 4h | - |

**Entregáveis**:
- ✅ Chaves API protegidas
- ✅ Login funcionando
- ✅ Firestore seguro

---

### Fase 2: Correções Críticas de Código (2-3 semanas)

| Item | Prioridade | Esforço |
|------|------------|---------|
| 2.1 Corrigir violações Clean Arch | 🟠 | 8h |
| 3.1 Extrair código duplicado | 🟠 | 4h |
| 3.4 Corrigir StatelessWidget | 🔴 | 2h |
| 6.2 Adicionar await faltando | 🔴 | 1h |

**Entregáveis**:
- ✅ Arquitetura consistente
- ✅ Sem código duplicado
- ✅ Bugs corrigidos

---

### Fase 3: Testes (3-4 semanas)

| Item | Prioridade | Esforço |
|------|------------|---------|
| 5.1 Criar estrutura de testes | 🔴 | 8h |
| 5.2 Testes unitários use cases | 🔴 | 16h |
| 5.3 Testes de controllers | 🔴 | 16h |
| 5.4 Testes de widgets | 🟡 | 16h |

**Meta**: 70%+ de cobertura

---

### Fase 4: Otimizações (2-3 semanas)

| Item | Prioridade | Esforço |
|------|------------|---------|
| 2.3 Implementar GetIt | 🟡 | 8h |
| 4.1 Singleton para factories | 🟠 | 4h |
| 4.2 Paginação Firestore | 🟠 | 16h |
| 4.3 Paralelizar queries | 🟡 | 2h |

**Entregáveis**:
- ✅ Performance melhorada
- ✅ App escalável

---

### Fase 5: CI/CD e Automação (1-2 semanas)

| Item | Prioridade | Esforço |
|------|------------|---------|
| 8.1 GitHub Actions | 🟠 | 4h |
| 8.2 Makefile | 🟡 | 1h |
| 8.3 Pre-commit hooks | 🟡 | 2h |
| 7.1 Atualizar analysis_options | 🟠 | 1h |

**Entregáveis**:
- ✅ CI/CD funcionando
- ✅ Automação de tarefas

---

### Fase 6: UX e Polimento (2-3 semanas)

| Item | Prioridade | Esforço |
|------|------------|---------|
| 6.1 Estados de loading | 🟡 | 4h |
| 6.4 Acessibilidade | 🟡 | 16h |
| 3.5 Padronizar nomenclatura | 🟡 | 2h |
| 3.3 Remover código morto | 🟡 | 1h |

**Entregáveis**:
- ✅ UX consistente
- ✅ App acessível

---

## 10. 📊 Métricas de Sucesso

### KPIs Técnicos

| Métrica | Atual | Meta Fase 3 | Meta Fase 6 |
|---------|-------|-------------|-------------|
| Cobertura de Testes | 0% | 70% | 80% |
| Tempo de Build | ~2min | ~2min | <90s |
| Tamanho APK | ~20MB | ~20MB | <18MB |
| Issues Abertas | - | 0 críticos | 0 |
| Tech Debt | Alto | Médio | Baixo |

### Checklist de Qualidade

- [ ] Todas as issues críticas resolvidas
- [ ] 80%+ de cobertura de testes
- [ ] CI/CD funcionando
- [ ] Sem violações de Clean Architecture
- [ ] Firestore seguro com regras
- [ ] Autenticação implementada
- [ ] Performance otimizada (paginação)
- [ ] Documentação atualizada

---

## 11. 📁 Checklist de Arquivos a Modificar/Criar

### Segurança

- [ ] `lib/firebase_options.dart` - Remover chaves
- [ ] `lib/firebase_options_dev.dart` - Remover chaves
- [ ] `lib/firebase_options_prod.dart` - Remover chaves
- [ ] `firestore.rules` - **CRIAR**
- [ ] `.env.dev` - **CRIAR**
- [ ] `.env.prod` - **CRIAR**
- [ ] `lib/features/auth/` - **CRIAR feature completa**

### Arquitetura

- [ ] `lib/features/expense/domain/entities/expense_entity.dart` - Remover toModel()
- [ ] `lib/features/expense/domain/repositories/expense_repository.dart` - Usar Entity
- [ ] `lib/features/category/domain/entities/category_entity.dart` - Remover toModel()
- [ ] `lib/features/category/domain/repositories/category_repository.dart` - Usar Entity
- [ ] `lib/features/payment_method/domain/` - Renomear `use_cases/` → `usecases/`
- [ ] `lib/core/di/injection_container.dart` - **CRIAR** (se usar GetIt)

### Qualidade de Código

- [ ] `lib/core/data/firebase_error_handler_mixin.dart` - **CRIAR**
- [ ] `lib/features/expense/data/repositories/expense_firebase_repository.dart` - Refatorar
- [ ] `lib/features/debt/data/firebase_debt_repository.dart` - Refatorar + corrigir logs
- [ ] `lib/features/category/data/repositories/category_firebase_repository.dart` - Refatorar
- [ ] `lib/features/supermarket/presentation/supermarket_page.dart` - Remover código comentado
- [ ] `lib/main.dart` - Remover linha comentada
- [ ] `lib/features/category/presentation/category_page.dart` - Corrigir StatelessWidget
- [ ] `lib/features/payment_method/presentation/payment_method_page.dart` - Corrigir StatelessWidget
- [ ] `lib/features/debt/debit.dart` - Renomear para `debt.dart`
- [ ] `lib/features/payment_method/presentation/payment_method_notifier.dart` - Renomear para `*_controller.dart`

### Performance

- [ ] `lib/features/expense/data/repositories/expense_firebase_repository.dart` - Adicionar paginação
- [ ] `lib/features/debt/presentation/debt_controller.dart` - Paralelizar queries

### Testes

- [ ] `test/` - **CRIAR estrutura completa**
- [ ] `test/helpers/` - **CRIAR**
- [ ] `test/unit/features/expense/` - **CRIAR**
- [ ] `test/widget/` - **CRIAR**

### Configurações

- [ ] `analysis_options.yaml` - Remover ignore + adicionar regras
- [ ] `android/app/src/main/AndroidManifest.xml` - Adicionar permissões
- [ ] `.firebaserc` - Adicionar ambientes
- [ ] `pubspec.yaml` - Adicionar dependências

### CI/CD

- [ ] `.github/workflows/flutter_ci.yaml` - **CRIAR**
- [ ] `.github/workflows/code_quality.yaml` - **CRIAR**
- [ ] `Makefile` - **CRIAR**
- [ ] `lefthook.yml` - **CRIAR**

### Documentação

- [ ] `README.md` - Atualizar
- [ ] `CONTRIBUTING.md` - **CRIAR**
- [ ] `CHANGELOG.md` - **CRIAR**

---

## 12. 🎯 Próximos Passos

### Ação Imediata (Hoje)

1. **Rotacionar chaves de API** no Firebase Console
2. **Criar regras básicas** do Firestore
3. **Remover `must_be_immutable: ignore`** do analysis_options.yaml

### Esta Semana

1. Implementar autenticação básica
2. Corrigir violações da Clean Architecture
3. Adicionar testes para use cases críticos
4. Extrair código duplicado (mixin)

### Este Mês

1. Completar Fase 1 (Segurança)
2. Completar Fase 2 (Correções)
3. Iniciar Fase 3 (Testes)

---

## 📚 Recursos Adicionais

- [Firebase Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Flutter Testing](https://docs.flutter.dev/testing)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Performance](https://docs.flutter.dev/perf)

---

**Última Atualização**: 2025-12-18
**Versão do Documento**: 1.0
