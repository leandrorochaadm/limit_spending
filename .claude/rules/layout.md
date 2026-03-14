---
paths:
  - "lib/features/*/presentation/**"
  - "lib/core/ui/**"
---

# Layout Rules

## Posicionamento Flexivel
- Sem valores fixos de posicao — layout deve se ajustar automaticamente
- Descricoes longas -> texto sobe / curtas -> texto fica mais abaixo
- Usar `Spacer`, `Expanded` e `Flexible` em vez de valores fixos de `top`/`bottom`
- Preferir `SafeArea` para respeitar areas seguras do dispositivo

## Import Rules
- Use relative imports: `import '../../../../core/...';`
