---
paths:
  - "scripts/**"
  - "server/**"
  - "clyvo-server/**"
---

# Backend Rules (clyvo-server)

## Deploy

- **SEMPRE** usar `./scripts/deploy-backend-dev.sh fast` para deploys rapidos (sem migrations)
- **SOMENTE** usar `./scripts/deploy-backend-dev.sh` (sem fast) quando houver migrations pendentes
- **NUNCA** fazer commits desnecessarios - so commitar quando solicitado ou necessario
- Para QA: `./scripts/deploy-backend-qa.sh fast`

## Ambientes

| Ambiente | URL |
|----------|-----|
| DEV | api.clyvo.solutions |
| QA | qa.clyvo.solutions |
