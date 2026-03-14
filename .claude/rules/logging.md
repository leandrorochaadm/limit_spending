---
paths:
  - "lib/**/*.dart"
---

# Logging Rules

## NEVER use `print()` or `debugPrint()` — ALWAYS use `LoggerMixin`

Import: `@lib/core/logging/logger_provider.dart`

### Adding to classes
```dart
class MyClass with LoggerMixin {
  // logDebug, logInfo, logWarning, logError available
}
```

### Log Levels
| Method | Use for |
|--------|---------|
| `logDebug(msg, {metadata})` | Development/debugging info |
| `logInfo(msg, {metadata})` | Important state changes, milestones |
| `logWarning(msg, {metadata})` | Potential issues that don't stop execution |
| `logError(msg, {error, stackTrace})` | Actual errors needing attention |

### Also available: ConsoleLogger (standalone)
```dart
final _logger = ConsoleLogger(tag: 'MY_TAG');
_logger.d('Debug'); _logger.i('Info'); _logger.w('Warning'); _logger.e('Error');
```
