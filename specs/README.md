# Finance Specs

This folder centralizes the product documentation for **Finance**, the mobile personal finance app defined by the prompt and the backend model notes you provided.

## What lives here

- [Product overview](./product-overview.md)
- [Screen inventory](./screen-inventory.md)
- [User flows](./user-flows.md)
- [Design system](./design-system.md)
- [Data model](./data-model.md)

## Scope

- Mobile-first product for iOS and Android.
- Complete MVP+ for income, expenses, accounts, budgets, reports, recurring items, goals, alerts, and exports.
- UI screens are documented as product requirements, not just mockups.
- Data model favors simple finance tracking over heavy accounting.

## Base decisions

- UI uses the term **Accounts**, while backend modeling uses **payment_sources / wallets**.
- Transfers move money between sources and do not count as expenses.
- Reports and budgets are calculated from transaction data, not from manual summaries.
- Light mode is the default visual direction, with clear dark mode support.

