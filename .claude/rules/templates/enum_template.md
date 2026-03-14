---
paths:
  - "lib/core/enum/**"
---

# Enum Template

## Basic Enhanced Enum

File: `lib/core/enum/{enum_name}_enum.dart`

```dart
enum {EnumName}Enum {
  value1('Display Name 1'),
  value2('Display Name 2'),
  value3('Display Name 3');

  final String name;

  const {EnumName}Enum(this.name);

  static {EnumName}Enum? fromString(String? value) {
    if (value == null) return null;
    return {EnumName}Enum.values.cast<{EnumName}Enum?>().firstWhere(
      (e) => e?.name.toLowerCase() == value.toLowerCase(),
      orElse: () => null,
    );
  }
}
```

## With API Value

```dart
enum {EnumName}Enum {
  value1('Display 1', 'API_VALUE_1'),
  value2('Display 2', 'API_VALUE_2');

  final String name;
  final String apiValue;

  const {EnumName}Enum(this.name, this.apiValue);

  static {EnumName}Enum? fromString(String? value) {
    if (value == null) return null;
    return {EnumName}Enum.values.cast<{EnumName}Enum?>().firstWhere(
      (e) => e?.apiValue.toLowerCase() == value.toLowerCase() ||
             e?.name.toLowerCase() == value.toLowerCase(),
      orElse: () => null,
    );
  }
}
```

After creating, add export to `lib/core/enum/enum_export.dart`.
