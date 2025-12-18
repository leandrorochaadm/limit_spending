# Firestore Indexes - Paginação

Este documento descreve os índices compostos necessários para suportar paginação no Firestore.

## Índices Necessários

### 1. Expenses (Despesas)
- **Collection:** `expenses`
- **Fields:**
  - `categoryId` (Ascending)
  - `created` (Descending)
- **Motivo:** Necessário para paginação de despesas filtradas por categoria e ordenadas por data de criação

### 2. Debt (Dívidas)
- **Collection:** `debt`
- **Fields:**
  - `name` (Ascending)
- **Motivo:** Necessário para paginação de dívidas ordenadas por nome

### 3. Categories (Categorias)
- **Collection:** `categories`
- **Fields:**
  - `name` (Ascending)
- **Motivo:** Necessário para paginação de categorias ordenadas por nome

## Como Criar os Índices

### Opção 1: Firebase Console (Manual)
1. Acesse o Firebase Console
2. Navegue até Firestore Database > Indexes
3. Crie cada índice manualmente conforme especificado acima

### Opção 2: Firebase CLI (Automático)
```bash
# Instale o Firebase CLI se ainda não tiver
npm install -g firebase-tools

# Faça login
firebase login

# Inicialize o projeto (se ainda não foi)
firebase init firestore

# Deploy dos índices
firebase deploy --only firestore:indexes
```

## Arquivo de Configuração

O arquivo `firestore.indexes.json` contém a definição de todos os índices necessários.

## Observações

- Os índices serão criados automaticamente quando você tentar executar uma query que os requer
- No entanto, é recomendado criá-los manualmente para evitar erros em produção
- Índices simples (por um único campo) são criados automaticamente pelo Firestore
- Apenas índices compostos (múltiplos campos) precisam ser definidos
