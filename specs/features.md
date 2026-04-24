# Features

## Core features

- Onboarding and account setup
- Home dashboard with balance, income, expenses, savings, and insights
- Transaction list, search, filter, sort, and grouped views
- Add, edit, delete, and duplicate transactions
- Transfer between accounts
- Income and expense categories
- Custom categories with icon, color, and soft delete/archive
- Monthly budgets by category with warnings and over-budget states
- Reports with category charts and time range views
- Accounts / payment sources for cash, cards, savings, wallets, and investments
- Recurring transactions
- Bills and subscriptions
- Savings goals
- Notifications and reminders
- Export to CSV or PDF
- Settings and profile preferences

## Analysis and reporting

- Category spending chart for the current month
- Weekly, monthly, 3-month, 6-month, yearly, and custom date ranges
- Cash flow trends over time
- Income vs expense comparison
- Budget progress and alerts

## Data and interaction features already implied by the model or views

- Notes
- Tags
- Split transactions
- Receipt attachment placeholder
- Smart insight cards
- Empty states
- Loading states
- Error states
- Success confirmations
- Delete confirmation modals
- Dark mode support
- Local-first storage on device

## Features already covered in the current data model

- `payment_sources` for accounts/cards/wallets
- `categories.type` for income vs expense
- `budgets.alert_threshold_percent` for near-limit warnings
- `transactions.type` for income, expense, and transfer
- `transactions.deleted_at` for soft delete
- `transaction_splits` for split spending
- `transaction_tags` for tags
- `recurring_rules` for repeating items
- `savings_goals` and `goal_contributions`
- `bill_subscriptions`
- `notifications`

## Not stored as separate entities

- Charts
- Filters
- Tabs for week / month / year / custom range
- Insight cards
- Search results

These are derived from the local database, not stored as independent records.

