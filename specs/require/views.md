# View Documentation

This document describes the stitched views that were imported into `specs/require/`.

## State coverage across the export

- Loading states should be represented in the main list and dashboard screens using skeleton or placeholder content.
- Error states should show a clear recovery action, not just a message.
- Success states should confirm the action with a banner, sheet, or toast.
- Delete flows should always require confirmation.
- Budget warnings should surface before the limit is exceeded.
- Search flows should include a visible no-results empty state.

## Onboarding

- Purpose: explain the value proposition and let the user start quickly.
- Primary UI: hero message, brief supporting copy, start CTA, guest/sign-in action.
- Notes: this is the first trust-building screen.
- Assets: [screen.png](./onboarding/screen.png), [code.html](./onboarding/code.html)

## Account Setup

- Purpose: collect the minimum setup data before the first use.
- Primary UI: currency selection, starting balance, first account, optional provider label, optional monthly income, budgeting preference.
- Notes: keep the form short and low-friction.
- Assets: [screen.png](./account_setup/screen.png), [code.html](./account_setup/code.html)

## Dashboard

- Purpose: provide a fast daily summary of money, budgets, and recent activity.
- Primary UI: total balance, monthly income and expense summary, savings, category preview, insights, recent transactions, quick actions, FAB.
- Notes: this is the primary home view and the highest-frequency screen.
- Assets: [screen.png](./dashboard/screen.png), [code.html](./dashboard/code.html)

## Transactions

- Purpose: show the full ledger in a scannable format.
- Primary UI: search, filters, sort, grouped transaction list, income/expense color separation.
- Notes: the no-results state should be part of the screen behavior.
- Assets: [screen.png](./transactions/screen.png), [code.html](./transactions/code.html)

## Add Transaction

- Purpose: make transaction entry extremely fast.
- Primary UI: expense/income/transfer toggle, amount-first input, category and account selectors, date/time, note, tags, recurring toggle, split option.
- Notes: save action should be easy to reach with one hand.
- Assets: [screen.png](./add_transaction/screen.png), [code.html](./add_transaction/code.html)

## Transaction Details

- Purpose: expose the full record and all actions for a transaction.
- Primary UI: amount, category, source account, date, note, tags, recurrence info, edit/duplicate/delete actions.
- Notes: delete must be confirmed.
- Assets: [screen.png](./transaction_details/screen.png), [code.html](./transaction_details/code.html)

## Categories

- Purpose: manage category organization for expenses and income.
- Primary UI: category list, icon, color, budget summary, custom category action.
- Notes: income and expense categories should be visually separated.
- Assets: [screen.png](./categories/screen.png), [code.html](./categories/code.html)

## Budgets

- Purpose: show category budgets and overall monthly status.
- Primary UI: total budget, remaining budget, progress bars, warning states, over-budget state, edit CTA.
- Notes: use strong visual hierarchy for warnings.
- Assets: [screen.png](./budgets/screen.png), [code.html](./budgets/code.html)

## Reports

- Purpose: help users understand cash flow and spending trends.
- Primary UI: category distribution, income vs expense, line chart, time range tabs, custom range controls, insight cards.
- Notes: charts should be readable, not decorative.
- Assets: [screen.png](./reports/screen.png), [code.html](./reports/code.html)

## Accounts

- Purpose: present all payment sources in one place.
- Primary UI: account cards, individual balances, total balance, transfer action, add account action.
- Notes: the UI can say accounts while the backend uses payment sources; cards, cash, savings, wallets, and investments use the same balance logic.
- Assets: [screen.png](./accounts/screen.png), [code.html](./accounts/code.html)

## Transfer

- Purpose: move money between accounts without counting it as an expense.
- Primary UI: from account, to account, amount, date, note, confirmation state.
- Notes: transfer should not affect spending analytics.
- Assets: [screen.png](./transfer/screen.png), [code.html](./transfer/code.html)

## Recurring Transactions

- Purpose: manage repeating income and expense rules.
- Primary UI: recurring items list, upcoming items, frequency, active/inactive toggle, edit action.
- Notes: this screen should make scheduling understandable at a glance.
- Assets: [screen.png](./recurring_transactions/screen.png), [code.html](./recurring_transactions/code.html)

## Savings Goals

- Purpose: track progress toward savings targets.
- Primary UI: goal cards, target amount, current progress, deadline, contribute action.
- Notes: progress should feel motivating without being noisy.
- Assets: [screen.png](./savings_goals/screen.png), [code.html](./savings_goals/code.html)

## Notifications

- Purpose: keep alerts and reminders in one place.
- Primary UI: budget warnings, bill reminders, recurring reminders, unusual spending insights, goal milestones.
- Notes: alerts should be actionable, not just informational.
- Assets: [screen.png](./notifications/screen.png), [code.html](./notifications/code.html)

## Settings

- Purpose: configure app preferences and support options.
- Primary UI: currency, theme, dark mode, notifications, security, backup/sync, language, help.
- Notes: keep advanced settings grouped away from daily money actions.
- Assets: [screen.png](./settings/screen.png), [code.html](./settings/code.html)

## Empty State

- Purpose: represent the no-data condition for the app and its major lists.
- Primary UI: empty-state illustration/message, next-step CTA, helpful hint.
- Notes: should be used by transactions, budgets, reports, and onboarding-adjacent flows.
- Assets: [screen.png](./empty_state/screen.png), [code.html](./empty_state/code.html)
