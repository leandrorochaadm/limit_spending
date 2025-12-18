# Limit Spending - Guia de Desenvolvimento

## Visão Geral

**Limit Spending** é um aplicativo Flutter para controle de gastos pessoais desenvolvido com Clean Architecture. O app permite gerenciar despesas, categorias, meios de pagamento, dívidas e listas de supermercado.

### Tecnologias Principais

- **Flutter**: SDK ^3.6.0 (gerenciado via FVM)
- **Firebase Firestore**: Banco de dados NoSQL
- **ValueNotifier**: Gerenciamento de estado nativo do Flutter
- **Equatable**: Comparação de objetos imutáveis
- **Clean Architecture**: Separação em camadas Domain, Data e Presentation

### Funcionalidades

- Controle de despesas por categoria
- Gerenciamento de categorias com limites mensais
- Meios de pagamento (cartões e dinheiro)
- Controle de dívidas
- Lista de compras de supermercado

---

## Arquitetura

### Clean Architecture - 3 Camadas

O projeto segue Clean Architecture com separação clara de responsabilidades:

```
lib/
├── core/                    # Módulo compartilhado (cross-cutting)
│   ├── constants/           # Constantes globais
│   ├── enums/               # Enumerações
│   ├── exceptions/          # Exceções customizadas
│   ├── extensions/          # Extensions de tipos (String, double, etc.)
│   ├── factories/           # Injeção de dependência manual
│   ├── services/            # Serviços auxiliares (logger, etc.)
│   ├── theme_custom/        # Tema dark personalizado
│   ├── use_case/            # Base abstrata para use cases
│   └── widgets/             # Widgets reutilizáveis
└── features/                # Módulos de funcionalidades
    └── [feature_name]/      # Ex: expense, category, payment_method
        ├── data/
        │   ├── models/      # Models com toJson/fromJson
        │   └── repositories/# Implementações de repositórios (Firebase)
        ├── domain/
        │   ├── entities/    # Entidades puras de negócio
        │   ├── repositories/# Interfaces de repositório (contratos)
        │   └── usecases/    # Casos de uso (regras de negócio)
        └── presentation/
            ├── controllers/ # Controllers com ValueNotifier
            ├── states/      # Estados imutáveis
            └── pages/       # Telas/páginas
```

### Fluxo de Dados

```
UI (Page)
  ↓ eventos do usuário
Controller (ValueNotifier)
  ↓ chama
UseCase
  ↓ usa
Repository Interface (Domain)
  ↑ implementa
Repository Implementation (Data)
  ↓ acessa
Firebase Firestore
```

---

## Convenções de Nomenclatura

### Arquivos

Sempre use sufixos para identificar o tipo de arquivo:

- `*_entity.dart` - Entidades do domínio (ex: `expense_entity.dart`)
- `*_model.dart` - Modelos de dados (ex: `expense_model.dart`)
- `*_repository.dart` - Interfaces e implementações (ex: `expense_repository.dart`)
- `*_usecase.dart` - Casos de uso (ex: `create_expense_usecase.dart`)
- `*_controller.dart` - Controllers (ex: `expense_controller.dart`)
- `*_state.dart` - Estados (ex: `expense_state.dart`)
- `*_page.dart` - Páginas/Telas (ex: `expense_page.dart`)
- `*_factory.dart` - Factories para DI (ex: `expense_factory.dart`)

### Barrel Files

Cada módulo possui arquivos de exportação para facilitar imports:

```dart
// lib/features/expense/data/data.dart
export 'models/expense_model.dart';
export 'repositories/expense_firebase_repository.dart';

// lib/features/expense/expense.dart
export 'data/data.dart';
export 'domain/domain.dart';
export 'presentation/presentation.dart';
```

### Nomenclatura de Código

- **Classes e Enums**: PascalCase (`ExpenseEntity`, `ExpenseStatus`)
- **Métodos e variáveis**: camelCase (`createExpense`, `expenseList`)
- **Arquivos**: snake_case (`expense_entity.dart`)
- **Constantes**: camelCase com const (`const daysFilter = 30`)
- **Idioma do código**: Inglês
- **Comentários**: Podem ser em português

---

## Padrões de Código

### 1. Repository Pattern

**Interface no Domain (contrato):**

```dart
// lib/features/expense/domain/repositories/expense_repository.dart
abstract class ExpenseRepository {
  Future<List<ExpenseEntity>> getExpenses({required String categoryId});
  Future<void> createExpense(ExpenseModel expense);
  Future<void> deleteExpense(String expenseId);
}
```

**Implementação no Data (Firebase):**

```dart
// lib/features/expense/data/repositories/expense_firebase_repository.dart
class ExpenseFirebaseRepository implements ExpenseRepository {
  final FirebaseFirestore firestore;

  ExpenseFirebaseRepository({required this.firestore});

  @override
  Future<List<ExpenseEntity>> getExpenses({required String categoryId}) async {
    final snapshot = await firestore
        .collection('expenses')
        .where('categoryId', isEqualTo: categoryId)
        .get();

    return snapshot.docs.map((doc) => ExpenseModel.fromJson(doc.data())).toList();
  }

  // ... outras implementações
}
```

### 2. Use Case Pattern

Cada operação de negócio é encapsulada em uma classe:

```dart
// lib/features/expense/domain/usecases/create_expense_usecase.dart
class CreateExpenseUseCase {
  final ExpenseRepository expenseRepository;

  CreateExpenseUseCase({required this.expenseRepository});

  Future<Failure?> call(ExpenseEntity expenseEntity) async {
    try {
      final expenseModel = ExpenseModel.fromEntity(expenseEntity);
      await expenseRepository.createExpense(expenseModel);
      return null; // sucesso
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro desconhecido: $e');
    }
  }
}
```

### 3. Retorno com Tupla (Failure?, Result?)

Padrão de retorno para operações que podem falhar:

```dart
// Use case retorna tupla
Future<(Failure?, List<ExpenseEntity>?)> call() async {
  try {
    final expenses = await expenseRepository.getExpenses();
    return (null, expenses); // sucesso
  } on AppException catch (e) {
    return (Failure(e.message), null); // falha
  }
}

// Controller usa o retorno
final (failure, expenses) = await getExpensesUseCase.call();
if (failure != null) {
  state.value = state.value.copyWith(
    status: ExpenseStatus.error,
    errorMessage: failure.message,
  );
  return;
}
state.value = state.value.copyWith(
  status: ExpenseStatus.success,
  expenses: expenses!,
);
```

### 4. Factory Pattern para Injeção de Dependência

Factories manuais no lugar de containers de DI:

```dart
// lib/core/factories/expense_factory.dart

// Repositório
ExpenseRepository makeExpenseRepository() => ExpenseFirebaseRepository(
      firestore: makeFirestoreFactory(),
      categoryRepository: makeCategoryRepository(),
    );

// Use Cases
CreateExpenseUseCase makeCreateExpenseUseCase() {
  return CreateExpenseUseCase(
    expenseRepository: makeExpenseRepository(),
  );
}

GetExpensesUseCase makeGetExpensesUseCase() {
  return GetExpensesUseCase(
    expenseRepository: makeExpenseRepository(),
  );
}

// Controller
ExpenseController makeExpenseController({Function? onGoBack}) {
  return ExpenseController(
    createExpenseUseCase: makeCreateExpenseUseCase(),
    getExpensesUseCase: makeGetExpensesUseCase(),
    deleteExpenseUseCase: makeDeleteExpenseUseCase(),
    onGoBack: onGoBack,
  );
}

// Page (Factory para injeção)
Widget expensePageFactory({Function? onGoBack}) {
  return ExpensePage(
    controller: makeExpenseController(onGoBack: onGoBack),
  );
}
```

### 5. ValueNotifier para Gerenciamento de Estado

```dart
// Controller
class ExpenseController {
  // Dependencies
  final CreateExpenseUseCase createExpenseUseCase;
  final GetExpensesUseCase getExpensesUseCase;

  // State
  ValueNotifier<ExpenseState> state = ValueNotifier<ExpenseState>(
    const ExpenseState(status: ExpenseStatus.initial),
  );

  // Constructor
  ExpenseController({
    required this.createExpenseUseCase,
    required this.getExpensesUseCase,
  });

  // Methods
  Future<void> load() async {
    state.value = state.value.copyWith(status: ExpenseStatus.loading);

    final (failure, expenses) = await getExpensesUseCase.call();

    if (failure != null) {
      state.value = state.value.copyWith(
        status: ExpenseStatus.error,
        errorMessage: failure.message,
      );
      return;
    }

    state.value = ExpenseState(
      status: ExpenseStatus.success,
      expenses: expenses ?? [],
    );
  }

  void dispose() {
    state.dispose();
  }
}
```

**Alternativa: Controller herdando de ValueNotifier**

```dart
class SupermarketController extends ValueNotifier<SupermarketState> {
  SupermarketController() : super(SupermarketState.initial()) {
    load();
  }

  Future<void> load() async {
    value = value.copyWith(status: SupermarketStatus.loading);

    final (failure, products) = await getProductsUseCase.call();

    if (failure != null) {
      value = value.copyWith(
        status: SupermarketStatus.error,
        errorMessage: failure.message,
      );
      return;
    }

    value = value.copyWith(
      status: SupermarketStatus.success,
      products: products ?? [],
    );
  }
}
```

### 6. States Imutáveis com Equatable

```dart
enum ExpenseStatus { initial, loading, success, error }

class ExpenseState extends Equatable {
  final ExpenseStatus status;
  final List<ExpenseEntity> expenses;
  final String? errorMessage;

  const ExpenseState({
    required this.status,
    this.expenses = const [],
    this.errorMessage,
  });

  ExpenseState copyWith({
    ExpenseStatus? status,
    List<ExpenseEntity>? expenses,
    String? errorMessage,
  }) {
    return ExpenseState(
      status: status ?? this.status,
      expenses: expenses ?? this.expenses,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, expenses, errorMessage];
}
```

### 7. Pages com ValueListenableBuilder

```dart
class ExpensePage extends StatefulWidget {
  final ExpenseController controller;

  const ExpensePage({super.key, required this.controller});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ExpenseState>(
      valueListenable: widget.controller.state,
      builder: (context, state, __) {
        return Scaffold(
          appBar: AppBar(title: const Text('Despesas')),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(ExpenseState state) {
    return switch (state.status) {
      ExpenseStatus.initial => const SizedBox.shrink(),
      ExpenseStatus.loading => const Center(child: CircularProgressIndicator()),
      ExpenseStatus.error => Center(child: Text(state.errorMessage ?? 'Erro')),
      ExpenseStatus.success => _buildList(state.expenses),
    };
  }

  Widget _buildList(List<ExpenseEntity> expenses) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return ListTile(
          title: Text(expense.description),
          subtitle: Text(expense.value.toCurrency()),
        );
      },
    );
  }
}
```

### 8. Entities vs Models

**Entity (Domain)** - Pura, sem dependências:

```dart
class ExpenseEntity extends Equatable {
  final String id;
  final String description;
  final double value;
  final DateTime date;
  final String categoryId;

  const ExpenseEntity({
    required this.id,
    required this.description,
    required this.value,
    required this.date,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [id, description, value, date, categoryId];
}
```

**Model (Data)** - Com conversão JSON:

```dart
class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    required super.id,
    required super.description,
    required super.value,
    required super.date,
    required super.categoryId,
  });

  // Factory para criar a partir de JSON (Firestore)
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      description: json['description'] as String,
      value: (json['value'] as num).toDouble(),
      date: (json['date'] as Timestamp).toDate(),
      categoryId: json['categoryId'] as String,
    );
  }

  // Converter para JSON (Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'value': value,
      'date': Timestamp.fromDate(date),
      'categoryId': categoryId,
    };
  }

  // Factory para criar a partir de Entity
  factory ExpenseModel.fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      id: entity.id,
      description: entity.description,
      value: entity.value,
      date: entity.date,
      categoryId: entity.categoryId,
    );
  }
}
```

---

## Tratamento de Erros

### Exceções Customizadas

```dart
// lib/core/exceptions/app_exception.dart
abstract class AppException implements Exception {
  final String message;
  AppException(this.message);
}

class PermissionDeniedException extends AppException {
  PermissionDeniedException([super.message = 'Permissão negada']);
}

class NetworkErrorException extends AppException {
  NetworkErrorException([super.message = 'Erro de conexão']);
}

class ResourceNotFoundException extends AppException {
  ResourceNotFoundException([super.message = 'Recurso não encontrado']);
}

class UnknownErrorException extends AppException {
  UnknownErrorException([super.message = 'Erro desconhecido']);
}
```

### Classe Failure

```dart
// lib/core/exceptions/failure.dart
class Failure {
  final String message;
  Failure(this.message);
}
```

### Tratamento em Repositórios

```dart
class ExpenseFirebaseRepository implements ExpenseRepository {
  @override
  Future<void> createExpense(ExpenseModel expense) async {
    try {
      await firestore.collection('expenses').doc(expense.id).set(expense.toJson());
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw PermissionDeniedException();
      } else if (e.code == 'unavailable') {
        throw NetworkErrorException();
      } else {
        throw UnknownErrorException(e.message ?? 'Erro ao criar despesa');
      }
    } catch (e) {
      throw UnknownErrorException('Erro inesperado: $e');
    }
  }
}
```

---

## Extensions

### DoubleExtensions

```dart
// lib/core/extensions/double_extensions.dart
extension DoubleExtensions on double {
  String toCurrency() {
    return NumberFormat.simpleCurrency(
      decimalDigits: 2,
      locale: 'pt_BR',
    ).format(this);
  }
}

// Uso
final value = 1234.56;
print(value.toCurrency()); // R$ 1.234,56
```

---

## Firebase e Ambientes

### Configuração de Ambientes

O projeto possui dois ambientes Firebase:

- **Desenvolvimento**: `limit-spending-dev`
- **Produção**: `limit-spending`

### Arquivos de Configuração

- `/lib/firebase_options.dart` - Arquivo ativo atual (copiado)
- `/lib/firebase_options_dev.dart` - Configurações DEV
- `/lib/firebase_options_prod.dart` - Configurações PROD

### Script de Troca de Ambiente

```bash
# Trocar para desenvolvimento
./switch_env.sh dev

# Trocar para produção
./switch_env.sh prod

# Reconfigurar com FlutterFire CLI
./switch_env.sh configure
```

### Inicialização no main.dart

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

### Estrutura de Coleções no Firestore

- `expenses` - Despesas
- `categories` - Categorias com limites mensais
- `payment_methods` - Meios de pagamento
- `debts` - Dívidas
- (outras coleções conforme necessário)

---

## Regras de Linting

### analysis_options.yaml

```yaml
analyzer:
  language:
    strict-casts: true      # Conversões de tipo explícitas
    strict-raw-types: true  # Tipos genéricos explícitos

linter:
  rules:
    - always_declare_return_types
    - cancel_subscriptions
    - close_sinks
    - require_trailing_commas   # Vírgulas finais obrigatórias
    - prefer_relative_imports   # Imports relativos dentro do projeto
```

### Importante

- **Trailing commas**: Obrigatórias em listas de argumentos com múltiplos itens
- **Imports relativos**: Use `import '../../../core/...` ao invés de `import 'package:limit_spending/core/...'`
- **Tipos explícitos**: Sempre declare tipos de retorno e evite `var` quando o tipo não é óbvio

---

## Comandos Úteis

### FVM (Flutter Version Management)

```bash
# Instalar dependências
fvm flutter pub get

# Executar app
fvm flutter run

# Build APK
fvm flutter build apk

# Build App Bundle
fvm flutter build appbundle

# Analisar código
fvm dart analyze

# Limpar build
fvm flutter clean
```

### Ambientes

```bash
# Trocar para desenvolvimento
./switch_env.sh dev

# Trocar para produção
./switch_env.sh prod
```

### Git

```bash
# Status
git status

# Adicionar mudanças
git add .

# Commit
git commit -m "feat: nova funcionalidade"

# Push
git push origin main
```

---

## Regras para o Claude

Ao trabalhar neste projeto, siga estas diretrizes:

### Arquitetura

1. **Sempre use Clean Architecture** com 3 camadas (Domain, Data, Presentation)
2. **Organize por features** (`lib/features/[feature_name]/`)
3. **Separe entidades de models** (Entity no domain, Model no data)
4. **Use interfaces de repositório** no domain, implementações no data

### Gerenciamento de Estado

5. **Nunca adicione pacotes externos de estado** (BLoC, Provider, GetX, Riverpod)
6. **Use ValueNotifier** para estado reativo
7. **States devem ser imutáveis** e herdar de Equatable
8. **Implemente método copyWith** em todos os states
9. **Use enums para status** (initial, loading, success, error)

### Injeção de Dependência

10. **Factories manuais** no lugar de containers de DI
11. **Crie factories no `/core/factories/`** para cada módulo
12. **Factories de pages** devem retornar Widget completo com controller injetado

### Tratamento de Erros

13. **Retorne tuplas** `(Failure?, Result?)` em use cases
14. **Lance exceções customizadas** em repositórios
15. **Trate exceções** do Firebase e converta para AppException

### Código e Estilo

16. **Código em inglês**, comentários podem ser em português
17. **Trailing commas obrigatórias** em listas multilinhas
18. **Imports relativos** para arquivos do projeto
19. **Siga nomenclatura de sufixos** (_entity, _model, _repository, etc.)
20. **Crie barrel files** (data.dart, domain.dart, presentation.dart)

### Firebase

21. **Use ambientes separados** (dev/prod)
22. **Acesse Firestore via factories** (`makeFirestoreFactory()`)
23. **Converta Timestamps** para DateTime ao buscar dados

### Widgets e UI

24. **Use ValueListenableBuilder** para observar estado
25. **Dispose controllers** no dispose() do State
26. **Use switch expressions** para mapear status para widgets
27. **Tema dark customizado** já está configurado

### Testes

28. **Não existem testes ainda** - se for adicionar, use estrutura similar (unit, widget, integration)

---

## Checklist para Nova Feature

Ao criar uma nova feature, siga este checklist:

### 1. Domain Layer

- [ ] Criar entidade em `domain/entities/xxx_entity.dart`
- [ ] Criar interface de repositório em `domain/repositories/xxx_repository.dart`
- [ ] Criar use cases em `domain/usecases/`
- [ ] Criar `domain/domain.dart` (barrel file)

### 2. Data Layer

- [ ] Criar model em `data/models/xxx_model.dart` (com fromJson/toJson)
- [ ] Criar implementação de repositório em `data/repositories/xxx_firebase_repository.dart`
- [ ] Criar `data/data.dart` (barrel file)

### 3. Presentation Layer

- [ ] Criar enum de status em `presentation/states/xxx_state.dart`
- [ ] Criar state imutável em `presentation/states/xxx_state.dart`
- [ ] Criar controller em `presentation/controllers/xxx_controller.dart`
- [ ] Criar page em `presentation/pages/xxx_page.dart`
- [ ] Criar `presentation/presentation.dart` (barrel file)

### 4. Core/Factories

- [ ] Criar `core/factories/xxx_factory.dart`
- [ ] Adicionar factory de repositório
- [ ] Adicionar factories de use cases
- [ ] Adicionar factory de controller
- [ ] Adicionar factory de page

### 5. Integração

- [ ] Adicionar rota ou navegação no app
- [ ] Testar fluxo completo
- [ ] Verificar tratamento de erros
- [ ] Validar com `dart analyze`

---

## Exemplo Completo: Criando Feature "Task"

### 1. Entidade

```dart
// lib/features/task/domain/entities/task_entity.dart
class TaskEntity extends Equatable {
  final String id;
  final String title;
  final bool completed;
  final DateTime createdAt;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.completed,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, completed, createdAt];
}
```

### 2. Interface de Repositório

```dart
// lib/features/task/domain/repositories/task_repository.dart
abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks();
  Future<void> createTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
}
```

### 3. Use Case

```dart
// lib/features/task/domain/usecases/create_task_usecase.dart
class CreateTaskUseCase {
  final TaskRepository taskRepository;

  CreateTaskUseCase({required this.taskRepository});

  Future<Failure?> call(TaskEntity taskEntity) async {
    try {
      final taskModel = TaskModel.fromEntity(taskEntity);
      await taskRepository.createTask(taskModel);
      return null;
    } on AppException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure('Erro ao criar tarefa: $e');
    }
  }
}
```

### 4. Model

```dart
// lib/features/task/data/models/task_model.dart
class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    required super.completed,
    required super.createdAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      completed: json['completed'] as bool,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      completed: entity.completed,
      createdAt: entity.createdAt,
    );
  }
}
```

### 5. Repositório Firebase

```dart
// lib/features/task/data/repositories/task_firebase_repository.dart
class TaskFirebaseRepository implements TaskRepository {
  final FirebaseFirestore firestore;

  TaskFirebaseRepository({required this.firestore});

  @override
  Future<List<TaskEntity>> getTasks() async {
    try {
      final snapshot = await firestore.collection('tasks').get();
      return snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    }
  }

  @override
  Future<void> createTask(TaskModel task) async {
    try {
      await firestore.collection('tasks').doc(task.id).set(task.toJson());
    } on FirebaseException catch (e) {
      throw _handleFirebaseException(e);
    }
  }

  AppException _handleFirebaseException(FirebaseException e) {
    if (e.code == 'permission-denied') {
      return PermissionDeniedException();
    } else if (e.code == 'unavailable') {
      return NetworkErrorException();
    } else {
      return UnknownErrorException(e.message ?? 'Erro no Firebase');
    }
  }
}
```

### 6. State

```dart
// lib/features/task/presentation/states/task_state.dart
enum TaskStatus { initial, loading, success, error }

class TaskState extends Equatable {
  final TaskStatus status;
  final List<TaskEntity> tasks;
  final String? errorMessage;

  const TaskState({
    required this.status,
    this.tasks = const [],
    this.errorMessage,
  });

  TaskState copyWith({
    TaskStatus? status,
    List<TaskEntity>? tasks,
    String? errorMessage,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, tasks, errorMessage];
}
```

### 7. Controller

```dart
// lib/features/task/presentation/controllers/task_controller.dart
class TaskController {
  final GetTasksUseCase getTasksUseCase;
  final CreateTaskUseCase createTaskUseCase;

  ValueNotifier<TaskState> state = ValueNotifier<TaskState>(
    const TaskState(status: TaskStatus.initial),
  );

  TaskController({
    required this.getTasksUseCase,
    required this.createTaskUseCase,
  });

  Future<void> load() async {
    state.value = state.value.copyWith(status: TaskStatus.loading);

    final (failure, tasks) = await getTasksUseCase.call();

    if (failure != null) {
      state.value = state.value.copyWith(
        status: TaskStatus.error,
        errorMessage: failure.message,
      );
      return;
    }

    state.value = TaskState(
      status: TaskStatus.success,
      tasks: tasks ?? [],
    );
  }

  Future<void> createTask(String title) async {
    final task = TaskEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      completed: false,
      createdAt: DateTime.now(),
    );

    final failure = await createTaskUseCase.call(task);

    if (failure != null) {
      state.value = state.value.copyWith(
        status: TaskStatus.error,
        errorMessage: failure.message,
      );
      return;
    }

    await load(); // Recarregar lista
  }

  void dispose() {
    state.dispose();
  }
}
```

### 8. Page

```dart
// lib/features/task/presentation/pages/task_page.dart
class TaskPage extends StatefulWidget {
  final TaskController controller;

  const TaskPage({super.key, required this.controller});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarefas')),
      body: ValueListenableBuilder<TaskState>(
        valueListenable: widget.controller.state,
        builder: (context, state, __) {
          return switch (state.status) {
            TaskStatus.initial => const SizedBox.shrink(),
            TaskStatus.loading => const Center(
                child: CircularProgressIndicator(),
              ),
            TaskStatus.error => Center(
                child: Text(state.errorMessage ?? 'Erro'),
              ),
            TaskStatus.success => ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return ListTile(
                    title: Text(task.title),
                    trailing: Checkbox(
                      value: task.completed,
                      onChanged: (_) {},
                    ),
                  );
                },
              ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog() {
    // Implementar dialog para criar tarefa
  }
}
```

### 9. Factory

```dart
// lib/core/factories/task_factory.dart

// Repositório
TaskRepository makeTaskRepository() => TaskFirebaseRepository(
      firestore: makeFirestoreFactory(),
    );

// Use Cases
GetTasksUseCase makeGetTasksUseCase() {
  return GetTasksUseCase(taskRepository: makeTaskRepository());
}

CreateTaskUseCase makeCreateTaskUseCase() {
  return CreateTaskUseCase(taskRepository: makeTaskRepository());
}

// Controller
TaskController makeTaskController() {
  return TaskController(
    getTasksUseCase: makeGetTasksUseCase(),
    createTaskUseCase: makeCreateTaskUseCase(),
  );
}

// Page Factory
Widget taskPageFactory() {
  return TaskPage(controller: makeTaskController());
}
```

---

## Recursos Adicionais

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase for Flutter](https://firebase.google.com/docs/flutter/setup)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

**Última atualização**: 2025-12-18
