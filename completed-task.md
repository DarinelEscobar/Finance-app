# Completed MVP Tasks

Este archivo registra tareas completadas, validadas y confirmadas funcionales. Una tarea solo debe moverse desde `task.md` hacia este archivo despues de cumplir sus criterios de aceptacion, pasar validaciones tecnicas y corroborar que respeta la carpeta `specs/`.

## Completion Rules

- No registrar tareas incompletas.
- No registrar tareas que solo compilan pero no cumplen specs.
- Registrar el bloque completo de la tarea completada.
- Agregar branch final, commit hash, fecha de cierre, validaciones ejecutadas y specs verificados.
- Mantener orden cronologico por ID.

## Completed Task Template

```md
## 000 - Task Name

- **ID:** `000`
- **Name:** Task Name
- **Final branch:** `task/000-task-name`
- **Commit hash:** `pending`
- **Closed date:** `YYYY-MM-DD`
- **Specs verified:**
  - `specs/...`
- **Validations executed:**
  - `flutter analyze`
  - `flutter test`
- **Implementation summary:**
  - Summary of completed work.
- **Functional result:**
  - Confirmation that the feature works locally and meets specs.
- **Risks or follow-up:**
  - None, or list known follow-up items.
```

## Completed Tasks

## 001 - Local Data Foundation

- **ID:** `001`
- **Name:** Local Data Foundation
- **Final branch:** `task/001-local-data-foundation`
- **Commit hash:** `30eb514`
- **Closed date:** `2026-04-24`
- **Specs verified:**
  - `specs/data-model.md`
  - `specs/local-storage.md`
  - `specs/features.md`
  - `specs/user-flows.md`
- **Validations executed:**
  - `dart run build_runner build --force-jit --delete-conflicting-outputs`
  - `flutter analyze`
  - `flutter test`
- **Implementation summary:**
  - Added Drift + SQLite dependencies, generated local schema, database connection, domain enums, default categories, repository setup flow, and transaction service balance rules.
  - Created local tables for users, settings, payment sources, categories, transactions, splits, tags, budgets, recurring rules, savings goals, bills, and notifications.
  - Added in-memory database tests for setup seeding, income, expense, transfer, and soft delete balance reversal.
- **Functional result:**
  - The app has a local-first SQLite/Drift foundation with no runtime dependency on external APIs or remote databases.
  - Income increases balances, expenses decrease balances, transfers move money between sources without becoming expenses, and soft delete reverts posted balance effects.
- **Risks or follow-up:**
  - `build_runner` requires `--force-jit` in this environment because the current Dart/Flutter toolchain fails AOT build-script compilation when packages expose build hooks.
