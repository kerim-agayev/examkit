---
name: ExamKit
colors:
  surface: '#FFFFFF'
  surface-dim: '#d6dade'
  surface-bright: '#f6fafe'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f0f4f8'
  surface-container: '#eaeef2'
  surface-container-high: '#e4e9ed'
  surface-container-highest: '#dfe3e7'
  on-surface: '#171c1f'
  on-surface-variant: '#434655'
  inverse-surface: '#2c3134'
  inverse-on-surface: '#edf1f5'
  outline: '#737686'
  outline-variant: '#c3c6d7'
  surface-tint: '#0053db'
  primary: '#004ac6'
  on-primary: '#ffffff'
  primary-container: '#2563eb'
  on-primary-container: '#eeefff'
  inverse-primary: '#b4c5ff'
  secondary: '#515f74'
  on-secondary: '#ffffff'
  secondary-container: '#d5e3fc'
  on-secondary-container: '#57657a'
  tertiary: '#006243'
  on-tertiary: '#ffffff'
  tertiary-container: '#007d57'
  on-tertiary-container: '#bdffdc'
  error: '#DC2626'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dbe1ff'
  primary-fixed-dim: '#b4c5ff'
  on-primary-fixed: '#00174b'
  on-primary-fixed-variant: '#003ea8'
  secondary-fixed: '#d5e3fc'
  secondary-fixed-dim: '#b9c7df'
  on-secondary-fixed: '#0d1c2e'
  on-secondary-fixed-variant: '#3a485b'
  tertiary-fixed: '#85f8c4'
  tertiary-fixed-dim: '#68dba9'
  on-tertiary-fixed: '#002114'
  on-tertiary-fixed-variant: '#005137'
  background: '#f6fafe'
  on-background: '#171c1f'
  surface-variant: '#dfe3e7'
  primary-light: '#DBEAFE'
  primary-dark: '#1E40AF'
  success: '#059669'
  success-light: '#D1FAE5'
  warning: '#D97706'
  warning-light: '#FEF3C7'
  error-light: '#FEE2E2'
  info: '#0284C7'
  info-light: '#E0F2FE'
  text-primary: '#0F172A'
  border: '#E2E8F0'
typography:
  display:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline:
    fontFamily: Inter
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.01em
  title-lg:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  title-md:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
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
  label-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.01em
  caption:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  container-max-student: 480px
  gutter: 16px
  margin-mobile: 16px
  margin-desktop: 24px
---

## Brand & Style

The design system is engineered for **ExamKit**, a professional educational platform bridging the gap between teachers (power users) and students (mobile-first learners). The brand personality is rooted in reliability, academic rigor, and effortless utility. It avoids unnecessary flourishes to focus on cognitive clarity, ensuring that users aged 10 to 65 can navigate complex examination workflows without friction.

The chosen design style is **Corporate / Modern** with a strong influence from **Material Design 3**. It prioritizes a high-signal-to-noise ratio, utilizing generous white space and a systematic approach to hierarchy. The interface feels "institutional yet accessible"—dependable enough for a high-stakes exam environment, but friendly enough for daily classroom use.

**Key Brand Pillars:**
- **Inclusivity:** High legibility and large touch targets to accommodate older educators and diverse student devices.
- **Precision:** Clear boundaries, structured grids, and logical flow to reduce exam-related anxiety.
- **Efficiency:** A mobile-first philosophy that treats time as a finite resource for both the proctor and the test-taker.

## Colors

The color palette is functional and semantic, anchored by a vibrant **Primary Blue (#2563EB)** that denotes action and intelligence. 

- **Primary:** Used for the "North Star" actions—starting an exam, submitting grades, and primary navigation.
- **Semantic Palette:** Highly distinct hues for Success (Green), Warning (Amber), and Error (Red) ensure status changes are immediately recognizable, crucial for timed environments.
- **Neutrals:** We utilize a Slate-based neutral scale. The background is a soft **#F1F5F9** to reduce eye strain, while text primary is a deep **#0F172A** to maintain a high contrast ratio for accessibility.
- **Surfaces:** Pure white is reserved for cards and elevated containers to create a clear "layer" effect against the tinted background.

## Typography

This design system employs **Inter** exclusively across all platforms to ensure a unified, technical, and highly legible appearance. 

**Accessibility Constraint:** In compliance with the needs of the 60+ age group, the absolute minimum size for body text is **16px**. Scale up to **18px** for primary reading content (exam questions).

- **Headlines:** Use tighter letter-spacing and bold weights to command attention.
- **Body Text:** Maintains a generous line height (1.5x) to prevent "line-skipping" during long reading sessions.
- **Turkish/Azerbaijani Support:** Ensure the Inter font-face includes the full Latin Extended glyph set to correctly render characters like "ə", "ğ", "ş", and "ı".

## Layout & Spacing

The design system utilizes a **strict 8dp grid rhythm**. All margins, paddings, and component heights must be multiples of 8 (or 4 for micro-adjustments).

**Platform Specifics:**
- **Teacher App (Flutter):** Fluid layout using 16px side margins. High-density information lists should maintain a minimum 64dp row height to ensure touch accuracy.
- **Student Web (Next.js):** Follows a **fixed-width mobile-first** approach. On larger screens, the content container is capped at **480px** and centered. This mimics the focused nature of a mobile device even on desktop, reducing the horizontal "scanning" distance for students taking exams.

**Breakpoints:**
- Mobile: < 600px (16px margins)
- Tablet/Desktop: > 600px (Centered container, increased vertical padding)

## Elevation & Depth

Hierarchy is established through **Tonal Layering** and **Subtle Shadows**. We avoid heavy drop shadows in favor of Material Design 3's elevation levels.

- **Level 0 (Background):** #F1F5F9. Used for the base canvas.
- **Level 1 (Cards/Surfaces):** #FFFFFF. Used for content blocks. These should have a 1px border (#E2E8F0) OR a very soft 2dp blur shadow to separate them from the background.
- **Level 2 (Modals/Bottom Sheets):** These use a higher elevation with a more pronounced shadow (8-12dp blur) and a semi-transparent scrim (#0F172A at 30% opacity) to dim the background content.
- **Interaction:** Buttons use a slight elevation increase on hover/pressed states to provide tactile feedback.

## Shapes

The shape language is **Rounded (Level 2)**, creating a professional yet modern feel. 

- **Small Components (8px):** Chips, badges, and small buttons.
- **Standard Components (12px):** Input fields and primary buttons.
- **Large Components (16px):** Standard content cards.
- **Extra Large (24px):** Bottom sheets (top corners only) and large modal containers.
- **Full Radius:** Reserved for Avatars and "Pill" style toggle buttons.

Avoid sharp 0px corners, as they appear too aggressive for an educational environment.

## Components

### Buttons
- **Primary:** 56dp height. Solid #2563EB with white 18sp Bold text. Full width on mobile/student web.
- **Secondary:** 56dp height. Outlined with 1.5dp #2563EB border.
- **Icon Buttons:** Minimum 48x48dp hit area to ensure accessibility.

### Input Fields
- **Standard:** 56dp height with 16sp text. Use "Float-up" labels.
- **States:** Border turns Primary #2563EB on focus, and Error #DC2626 on validation failure.

### Cards
- White background, 16px radius, 16px internal padding.
- Used to group exam details, student profiles, or question sets.

### Status Badges
- **Draft:** Warning colors (#D97706 on #FEF3C7).
- **Live:** Success colors with a pulsing dot icon next to the "Canlı" text.
- **Completed:** Neutral colors (#475569 on #F1F5F9).

### Navigation
- **Flutter:** Bottom navigation bar (72dp height) with 4 key destinations. Use active-state pills to highlight the current selection.
- **Web:** Simplified header with a clear back button for exam-taking focus.

### Feedback
- **Circular Progress:** Always use Primary Blue.
- **Snackbars:** Dark neutral background (#0F172A) with white text, positioned at the bottom of the screen.