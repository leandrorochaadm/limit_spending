---
paths:
  - "lib/core/enum/**"
---

# Enum Rules

## Location & Naming
- **MUST** be in `lib/core/enum/` with suffix `_enum.dart`
- One enum per file
- Export from `lib/core/enum/enum_export.dart`

## Structure - Enhanced Enums (REQUIRED)

All enums **MUST** be enhanced with:
1. `name` property (display name for UI)
2. `fromString` factory constructor (safe parsing from API/JSON)
3. Optional: `apiValue` for backend mapping

```dart
enum MyEnum {
  value1('Display 1'),
  value2('Display 2');

  final String name;
  const MyEnum(this.name);

  static MyEnum? fromString(String? value) {
    if (value == null) return null;
    return MyEnum.values.cast<MyEnum?>().firstWhere(
      (e) => e?.name.toLowerCase() == value.toLowerCase(),
      orElse: () => null,
    );
  }
}
```

## Template
- See `@.claude/rules/templates/enum_template.md`
