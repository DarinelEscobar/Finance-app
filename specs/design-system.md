# Design System

## Visual direction

- Clean premium fintech style
- Soft rounded cards
- Clear spacing and hierarchy
- Neutral base colors with carefully chosen accents
- Elegant typography
- Minimal but warm
- Mobile-first
- Light mode first, with a clear dark mode system
- Accessible contrast and touch-friendly controls

## Layout rules

- Use a strong top app bar for screen titles and key actions.
- Use a bottom navigation bar with 5 persistent tabs.
- Use a prominent FAB for the primary transaction action.
- Prefer 8pt-based spacing.
- Keep cards rounded but not overly decorative.

## Color system

Recommended token roles:

- `background`
- `surface`
- `surface-elevated`
- `primary`
- `secondary`
- `success`
- `warning`
- `danger`
- `income`
- `expense`
- `muted`
- `border`

Design guidance:

- Use calm neutrals for the base UI.
- Use green only where positive money movement is intended.
- Use red only for outflow, warnings, and destructive actions.
- Use category colors consistently across list rows, charts, and budget bars.

## Typography

- Title and amount values must be highly readable.
- Money figures should be visually dominant.
- Secondary labels should be lighter and smaller but still accessible.
- Keep copy calm, clear, and trustworthy.

## Core components

- App bar
- Bottom navigation
- Floating action button
- Input fields
- Dropdowns and selectors
- Date picker
- Cards
- Charts
- Progress bars
- Chips / tags
- Toggles
- Modals and bottom sheets
- Alerts / banners
- Empty states
- Primary, secondary, destructive, and disabled buttons

## Data visualization rules

- Pie or donut chart for category distribution
- Bar chart for income vs expenses
- Line chart for trend over time
- Budget progress bars for category limits
- Small insight cards for short takeaways

## Component states

Each core control should support:

- default
- focused
- filled
- disabled
- loading
- error
- success

For finance-specific patterns, also support:

- over budget
- near limit
- no data
- search empty
- confirmation pending

## Empty state tone

Empty states should feel useful, not vacant. They should explain what the user can do next, for example:

- add the first transaction
- create a category
- set a budget
- add a goal

## Accessibility

- Maintain contrast suitable for readable finance data.
- Use large touch targets.
- Avoid relying on color alone for income vs expense.
- Keep charts accompanied by labels and summary values.
- Support dark mode without losing contrast in cards, borders, and text.

