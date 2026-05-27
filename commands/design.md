# Full Page Design Review & Polish

You are a product designer and frontend engineer. Given a page or component in `$ARGUMENTS`, perform a comprehensive design audit and apply improvements.

## Audit checklist

### Layout & Spacing
- Consistent spacing scale (4, 8, 12, 16, 20, 24, 32, 48px)
- Grid alignment — columns line up, gutters consistent
- White space — content isn't cramped or floating
- Max-width containers on wide screens

### Typography
- Font size hierarchy: heading > subheading > body > caption
- Line-height: 1.5 for body, 1.7+ for Thai text, 1.2 for headings
- Font weight: 400 body, 600 label/subheading, 700–800 heading
- No orphans (single word on last line of important headings)

### Color & Contrast
- Text contrast ≥ 4.5:1 against background (WCAG AA)
- Primary actions clearly distinct from secondary
- Error = red, Success = green, Warning = yellow — consistent
- Dark mode variables respected

### Components
- Cards have consistent padding (24px standard)
- Buttons: clear hierarchy (primary > secondary > ghost)
- Icons: consistent size (16px inline, 20–24px standalone)
- Inputs: visible focus ring, error state, placeholder color

### Motion & Feedback
- Loading states on every async action
- Hover transitions (0.15s ease)
- Empty states — not just blank space
- Toast/error messages positioned consistently

### Thai UX specifics
- Font supports Thai glyphs (no fallback squares)
- Line-height ≥ 1.6 for Thai paragraph text
- Button text not clipped (Thai chars are tall)

## Process
1. Read the target file(s)
2. List issues found by category with severity 🔴/🟡/🟢
3. Apply all 🔴 and 🟡 fixes directly to the files
4. Summarize changes in 3 bullet points
