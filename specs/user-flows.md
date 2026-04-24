# User Flows

## Flow 1. First-time user setup

1. User opens the app and lands on onboarding.
2. User reads the value proposition and starts immediately or continues as guest.
3. User selects currency.
4. User creates the first payment source / account.
5. User optionally sets a starting balance and monthly income estimate.
6. User optionally chooses a budgeting preference.
7. User lands on the Home dashboard.

## Flow 2. Add first expense

1. User taps the FAB or the Add Transaction action.
2. User selects `expense`.
3. User enters amount first.
4. User picks category and account.
5. User adds note and tags if needed.
6. User saves the transaction.
7. Dashboard updates balances, budgets, and recent activity.

## Flow 3. Add first income

1. User opens Add Transaction.
2. User selects `income`.
3. User enters amount.
4. User selects source account and income category.
5. User optionally marks it recurring.
6. User saves.
7. Income summary cards and account balance refresh.

## Flow 4. Create a custom category

1. User opens Categories.
2. User taps Create category.
3. User enters the name, type, icon, and color.
4. User optionally assigns a budget.
5. User saves the category.
6. The category becomes available in transaction entry and reports.

## Flow 5. Set a monthly budget

1. User opens Budgets.
2. User chooses a category.
3. User sets a budget amount and warning threshold.
4. User saves.
5. Budget progress appears on the overview and category detail screens.
6. Supported periods stay simple: monthly default, weekly, 3 months, 6 months, 1 year, or custom date range.

## Flow 6. Transfer money between accounts

1. User opens Transfer Between Accounts.
2. User selects source account.
3. User selects destination account.
4. User enters amount and optional note.
5. User confirms the transfer.
6. Source and destination balances update without affecting expense analytics.

## Flow 7. View reports for a custom range

1. User opens Reports.
2. User selects weekly, monthly, yearly, or custom range.
3. User changes dates or filters.
4. Charts update for income, expense, and category distribution.
5. User inspects trends and cash flow insights.

## Flow 8. Create a recurring transaction

1. User opens Recurring.
2. User taps create or edit recurring rule.
3. User sets type, amount, category, source, and frequency.
4. User defines start and end dates if needed.
5. User enables or disables auto-post behavior.
6. App schedules the next run and shows the item in upcoming reminders.

## Flow 9. Add a savings goal

1. User opens Goals.
2. User creates a new goal with target amount and deadline.
3. User links a source if needed.
4. User contributes money to the goal.
5. Goal progress updates visually and milestone notifications can fire.

## Flow 10. Pay a bill or mark a subscription as paid

1. User opens Bills & Subscriptions.
2. User reviews an item due soon.
3. User marks it as paid or creates the matching transaction.
4. User sees the confirmation state.
5. Notifications and upcoming reminders update accordingly.

## Flow 11. Export, import, or reset local data

1. User opens Export / Data.
2. User exports all local data as a ZIP archive when they want a portable backup.
3. User shares or stores the ZIP file.
4. User imports the same ZIP file later to restore the full app state.
5. If the user chooses reset, the app clears all local data and returns to defaults.

## Shared interaction rules

- Editing a transaction must preserve balance correctness by applying deltas.
- Deleting a transaction should use a confirmation step and soft delete logic.
- Split transactions must total exactly the full amount.
- Search and filter screens need a clear no-results state.
- Budget warnings should surface before the limit is exceeded.
- No receipt images in the MVP; transactions store structured expense data only.
