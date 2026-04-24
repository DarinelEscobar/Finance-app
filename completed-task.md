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

## 002 - Onboarding / Welcome

- **ID:** `002`
- **Name:** Onboarding / Welcome
- **Final branch:** `task/002-onboarding`
- **Commit hash:** `0cc4b7a`
- **Closed date:** `2026-04-24`
- **Specs verified:**
  - `specs/product-overview.md`
  - `specs/screen-inventory.md`
  - `specs/user-flows.md`
  - `specs/design-system.md`
  - `specs/require/onboarding/screen.png`
  - `specs/require/onboarding/code.html`
- **Validations executed:**
  - `flutter analyze`
  - `flutter test`
- **Implementation summary:**
  - Refactored app startup into `FinanceApp`, `FinanceScope`, and `StartupGate`.
  - Added local startup routing for clean install, guest-without-setup, and setup-complete states.
  - Implemented onboarding with local-first copy, guest CTA, loading state, and navigation to account setup without remote auth.
- **Functional result:**
  - Clean local database opens onboarding; tapping the CTA creates a local guest user and routes to account setup.
  - Existing guest users without setup skip onboarding and open account setup directly.
- **Risks or follow-up:**
  - Account setup is intentionally a minimal destination in task 002 and is implemented fully in task 003.

## 003 - Account Setup

- **ID:** `003`
- **Name:** Account Setup
- **Final branch:** `task/003-account-setup`
- **Commit hash:** `0af7efe`
- **Closed date:** `2026-04-24`
- **Specs verified:**
  - `specs/data-model.md`
  - `specs/local-storage.md`
  - `specs/screen-inventory.md`
  - `specs/user-flows.md`
  - `specs/require/account_setup/screen.png`
  - `specs/require/account_setup/code.html`
- **Validations executed:**
  - `flutter analyze`
  - `flutter test`
- **Implementation summary:**
  - Replaced the account setup placeholder with a validated mobile form for currency, first account/payment source, source type, provider label, starting balance, monthly income estimate, and budget preference.
  - Persisted setup through SQLite/Drift using the local repository, including guest user, settings, first payment source, and default category seeds.
  - Added money parsing to minor units and widget coverage for validation, save, dashboard navigation, and stored local data.
- **Functional result:**
  - A guest user can complete setup offline, see a success state, land on the dashboard, and reopen into setup-complete state backed by local SQLite data.
  - Setup remains local-first and does not require internet, API auth, or a remote database.
- **Risks or follow-up:**
  - Dashboard still displays placeholder summary values until task 006 connects it to database-backed metrics.
