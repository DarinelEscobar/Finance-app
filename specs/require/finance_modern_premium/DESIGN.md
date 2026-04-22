---
name: Finance Modern Premium
colors:
  surface: '#f7f9fb'
  surface-dim: '#d8dadc'
  surface-bright: '#f7f9fb'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f4f6'
  surface-container: '#eceef0'
  surface-container-high: '#e6e8ea'
  surface-container-highest: '#e0e3e5'
  on-surface: '#191c1e'
  on-surface-variant: '#474651'
  inverse-surface: '#2d3133'
  inverse-on-surface: '#eff1f3'
  outline: '#777682'
  outline-variant: '#c8c5d3'
  surface-tint: '#5654a8'
  primary: '#1a146b'
  on-primary: '#ffffff'
  primary-container: '#312e81'
  on-primary-container: '#9c9af4'
  inverse-primary: '#c3c0ff'
  secondary: '#006c4a'
  on-secondary: '#ffffff'
  secondary-container: '#82f5c1'
  on-secondary-container: '#00714e'
  tertiary: '#500012'
  on-tertiary: '#ffffff'
  tertiary-container: '#790020'
  on-tertiary-container: '#ff7a85'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e2dfff'
  primary-fixed-dim: '#c3c0ff'
  on-primary-fixed: '#100563'
  on-primary-fixed-variant: '#3e3c8f'
  secondary-fixed: '#85f8c4'
  secondary-fixed-dim: '#68dba9'
  on-secondary-fixed: '#002114'
  on-secondary-fixed-variant: '#005137'
  tertiary-fixed: '#ffdada'
  tertiary-fixed-dim: '#ffb3b6'
  on-tertiary-fixed: '#40000c'
  on-tertiary-fixed-variant: '#920028'
  background: '#f7f9fb'
  on-background: '#191c1e'
  surface-variant: '#e0e3e5'
typography:
  display:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  h1:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  h2:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.01em
  label-caps:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  margin-mobile: 20px
  gutter-mobile: 16px
---

## Brand & Style

The design system is anchored in the concept of "Financial Serenity." It balances the technical precision required for banking with a soft, human-centric aesthetic that reduces the anxiety often associated with money management.

The visual style is **Modern Minimalist with Tonal Layering**. It prioritizes high-quality white space and a "quiet" interface where the user’s data remains the focal point. By utilizing soft edges and a restrained color palette, the design system evokes feelings of security, clarity, and premium craftsmanship. It avoids the clinical coldness of traditional banking in favor of a warm, approachable, yet highly professional environment.

## Colors

The color architecture of this design system utilizes a high-contrast primary Indigo to signal importance and reliability. The semantic palette is strictly defined: **Emerald** is reserved exclusively for income, growth, and successful states, while **Coral/Rose** signals expenses, debt, or critical warnings.

For Dark Mode, the background shifts to a Deep Slate (#0F172A) rather than pure black to maintain the premium "soft" feel. Neutral grays are used to create hierarchy through layering—lighter grays represent surfaces closer to the user. All color combinations are vetted against WCAG 2.1 AA standards to ensure financial data is legible for all users.

## Typography

This design system uses **Inter** for its exceptional legibility at small sizes and its modern, neutral character. 

Hierarchy is established through weight rather than just size. Headlines use a Semibold (600) or Bold (700) weight with slight negative letter-spacing to appear more "compact" and premium. Body text maintains a generous line-height to ensure that long lists of transactions remain scannable. Numeric data should utilize tabular lining (if available in the font settings) to ensure that decimal points align perfectly in vertical columns of numbers.

## Layout & Spacing

The design system employs a **fluid 4-column grid** for mobile devices. The standard horizontal margin is 20px, providing a spacious, breathable frame for content cards. 

Spacing follows an 8pt geometric scale (4, 8, 16, 24, 32, 48, 64). Internal padding within cards is standardized at 16px (Medium) or 20px for a more luxurious feel. Elements are grouped using proximity; related items (like a transaction title and its date) use 4px spacing, while distinct sections use 32px to provide clear visual breaks without the need for heavy dividers.

## Elevation & Depth

Depth in this design system is created through **Ambient Shadows** and tonal shifts rather than harsh lines. 

- **Level 0 (Base):** The primary background color. 
- **Level 1 (Cards):** Uses a very soft, diffused shadow (Y: 4, Blur: 20, Opacity: 4% of On-Surface color) to appear as if it is floating slightly above the base.
- **Level 2 (Active/Floating):** The Floating Action Button (FAB) and Bottom Sheets use a more pronounced shadow (Y: 8, Blur: 24, Opacity: 8%) to indicate high interactivity and "top-layer" priority.

Avoid using borders on cards unless they are appearing on a background of the same color; in those cases, use a 1px border in a slightly darker neutral tone.

## Shapes

The shape language is defined by **Soft Continuity**. Primary containers such as dashboard cards and bottom sheets use a 24px corner radius to evoke a modern, friendly feel. Smaller elements like buttons and input fields use a 12px-16px radius.

Interactive chips and tags utilize a fully rounded (pill) shape to distinguish them from structural containers. All touch targets must maintain a minimum height of 48px, even if the visual element (like a text link) appears smaller.

## Components

- **App Bar:** Centered titles for a premium feel. Action icons (Search, Profile) are placed at the edges. Uses a transparent background that becomes blurred on scroll.
- **5-Tab Bottom Navigation:** Icons use a 24pt stroke weight. The active state is indicated by the Primary Action color and a subtle 4px dot below the icon. No text labels are used for a cleaner aesthetic, provided the icons are universally recognizable.
- **Floating Action Button (FAB):** Positioned in the center of the bottom nav (docked) or the bottom right. It is a large circle (56x56) in the Primary Action color.
- **Input Fields:** Use a subtle gray fill (#F1F5F9) with no border in their default state. On focus, they transition to a white background with a 2px Primary Indigo border.
- **Charts:**
    - **Donut:** Uses a 12px stroke width with rounded caps.
    - **Line/Bar:** Use rounded terminals and soft gradients (fill under the line) for a "smooth" data visualization.
- **Progress Bars:** Thin 8px height with fully rounded caps. The background track is a 10% opacity version of the progress color.
- **Bottom Sheets:** Use a 24px top-radius and include a "grabber" handle (40x4px, rounded).
- **Chips/Tags:** Used for transaction categories (e.g., "Food", "Rent"). They use a light tint of the category color with high-contrast text.