# Skill: Refatoração de Screen

Skill otimizada para refatorar screens seguindo o padrão do projeto Clyvo Mobile.

---

## 🎯 Regras Obrigatórias

### 1. Cores - Usar AppColors

**NUNCA:**
- `Color(0xFF123456)` - cores inline
- `Colors.red`, `Colors.blue` - Material colors
- `.withOpacity()` - deprecated (perda de precisão)

**SEMPRE:**
- `AppColors.[color]` de `lib/core/theme/app_colors.dart`
- `.withValues(alpha: x)` ao invés de `.withOpacity(x)`
- Solicitar ao usuário se a cor não existir

```dart
// ❌ ERRADO
Container(color: Color(0xFF2D6BFF).withOpacity(0.5))

// ✅ CORRETO
Container(color: AppColors.primary.withValues(alpha: 0.5))
```

**Buscar cores:** `Read('lib/core/theme/app_colors.dart')`

---

### 2. TextStyles - Usar AppStyles

**NUNCA:**
- `GoogleFonts.poppins()`, `GoogleFonts.roboto()`
- `TextStyle()` inline sem necessidade

**SEMPRE:**
- `AppStyles.[style]` de `lib/core/theme/app_styles.dart`
- Nomenclatura: `s[size]w[weight][color]` (ex: `s14w600gray900`)
- Pode criar novos estilos se necessário

```dart
// ❌ ERRADO
Text('Hello', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700))

// ✅ CORRETO
Text('Hello', style: AppStyles.s14w700gray900)
```

**Buscar estilos:** `Read('lib/core/theme/app_styles.dart')`

---

### 3. Parâmetros - Usar Entity

**NUNCA:**
- `Map<String, dynamic>` como parâmetro

**SEMPRE:**
- Entity ou `List<Entity>`
- Criar nova Entity se necessário

```dart
// ❌ ERRADO
class MyScreen extends StatelessWidget {
  final Map<String, dynamic> data;
}

// ✅ CORRETO
class MyScreen extends StatelessWidget {
  final UserEntity user;
}
```

---

### 4. Imports - Usar Relativos

**NUNCA:**
- `import 'package:clyvo_mobile/...'` - imports absolutos

**SEMPRE:**
- Imports relativos (`../` ou `./`)
- Remover imports não utilizados (ex: `google_fonts`)

```dart
// ❌ ERRADO
import 'package:clyvo_mobile/core/theme/app_colors.dart';

// ✅ CORRETO (de lib/features/payment/presentation/screens/)
import '../../../../core/theme/app_colors.dart';
```

---

### 5. Comentários - Remover ignore_for_file

**SEMPRE** remover comentários `// ignore_for_file:` da primeira linha

```dart
// ❌ ERRADO - Remover esta linha
// ignore_for_file: unused_import, prefer_const_constructors

// ✅ CORRETO
import 'package:flutter/material.dart';
```

---

### 6. Widgets - Reutilizar de lib/core/ui/

**SEMPRE:**
- Verificar `lib/core/ui/` antes de criar widgets
- Consultar `core-reference.md` para widgets disponíveis

**NUNCA:**
- Criar widgets duplicados inline
- Criar loading/empty/error states customizados

```dart
// ❌ ERRADO
ElevatedButton(
  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
  child: Text('Continuar'),
)

// ✅ CORRETO
ClyvoButton(text: 'Continuar', onPressed: onPressed)
```

`**Categorias principais:**
- **buttons/** - ClyvoButton, ClyvoPrimaryButton, ClyvoActionButton
- **feedback/** - ClyvoLoadingIndicator, ClyvoEmptyState, ClyvoErrorMessage
- **inputs/** - CustomTextField, ClyvoSearchField, PhoneInputField, ClyvoCheckbox
- **navigation/** - ClaraAppBar, ClyvoBottomNavigationBar, AppTabBar
- **widgets/** - ClyvoAvatar, ClyvoGradientBackground, ClyvoLogoHeader
`
**Buscar widgets:** `Read('@.claude/rules/core-reference.md')` ou `Glob('lib/core/ui/**/*_export.dart')`

---

### 7. Erros - Usar ClyvoErrorMessage

**SEMPRE:**
- `ClyvoErrorMessage` de `lib/core/ui/widgets/clyvo_error_message.dart`

**NUNCA:**
- Widgets de erro inline
- `Text()` simples para erros

```dart
// ❌ ERRADO
Column(
  children: [
    Icon(Icons.error, color: Colors.red),
    Text('Erro ao carregar'),
  ],
)

// ✅ CORRETO
ClyvoErrorMessage(
  title: 'Erro ao carregar',
  description: 'Tente novamente',
  showRetryButton: true,
  onRetry: () => retry(),
)
```

---

## ✅ Checklist de Refatoração

```markdown
- [ ] Remover `// ignore_for_file:` da primeira linha
- [ ] Substituir cores inline por `AppColors.*`
- [ ] Substituir `.withOpacity()` por `.withValues(alpha: x)`
- [ ] Substituir `GoogleFonts.*()` por `AppStyles.*`
- [ ] Substituir `Map<String, dynamic>` por Entity
- [ ] Converter imports absolutos para relativos
- [ ] Remover import de `google_fonts`
- [ ] Verificar widgets de `lib/core/ui/` para reutilizar
- [ ] Substituir botões inline por componentes UI
- [ ] Substituir loading/empty/error inline por componentes UI
- [ ] Usar `ClyvoErrorMessage` para todos os erros
- [ ] Verificar que todas as cores existem em `AppColors`
- [ ] Verificar que todos os estilos existem em `AppStyles`
```

---

## 🔄 Processo de Refatoração

1. **Ler arquivo** da screen a ser refatorada
2. **Consultar recursos** sob demanda:
   - Cores: `Read('lib/core/theme/app_colors.dart')`
   - Estilos: `Read('lib/core/theme/app_styles.dart')`
   - Widgets: `Read('.claude/core-reference.md')`
3. **Identificar violações:**
   - Cores inline, `Colors.*`, `.withOpacity()`
   - `GoogleFonts.*()`, `TextStyle()` inline
   - `Map<String, dynamic>` em parâmetros
   - Imports absolutos
   - Widgets duplicados
   - Widgets de erro inline
4. **Verificar existência** de cores/estilos necessários
5. **Perguntar ao usuário** se precisar:
   - Criar novos `AppStyles`
   - Criar novos widgets em `lib/core/ui/`
   - Adicionar cores em `AppColors`
6. **Aplicar substituições** seguindo as regras
7. **Validar** que não há mais violações

---

## 📝 Exemplo Compacto

### Antes
```dart
// ignore_for_file: unused_import
import 'package:google_fonts/google_fonts.dart';
import 'package:clyvo_mobile/features/profile/domain/entities/user_entity.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Column(
        children: [
          Text(
            userData['name'] ?? '',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF212121),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
```

### Depois
```dart
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/ui/buttons/clyvo_primary_button.dart';
import '../../domain/entities/user_entity.dart';

class ProfileScreen extends StatelessWidget {
  final UserEntity user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      body: Column(
        children: [
          Text(user.name, style: AppStyles.s16w700gray900),
          ClyvoPrimaryButton(
            text: 'Save',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
```

---

## 🚀 Uso da Skill

Ao refatorar uma screen:

1. Ler a screen alvo
2. Aplicar checklist
3. Consultar recursos sob demanda (não carregar tudo antecipadamente)
4. Perguntar ao usuário quando necessário
5. Aplicar mudanças
6. Validar resultado

**Foco:** Código limpo, reutilização de componentes, padrões consistentes.

---

**Última atualização:** 2026-02-14
