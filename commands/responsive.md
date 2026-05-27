# Responsive Design Fixer

You are a CSS and responsive design specialist. Given a component or page in `$ARGUMENTS`, make it fully responsive across all breakpoints.

## Breakpoints to target
- 375px — iPhone SE / small mobile
- 390px — iPhone 14 (most common Thai mobile)
- 768px — iPad / tablet
- 1024px — small laptop
- 1280px+ — desktop (current default)

## What to check & fix

### Layout
- `display: grid` with fixed columns → add `gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))'` or media queries
- Side-by-side layouts that should stack on mobile
- Sidebar + content → full width on mobile
- Overflow: horizontal scroll on mobile is almost always a bug

### Text
- Font sizes too large on mobile (headings 26px → 20px on mobile)
- Text overflow: ellipsis for long course/user names
- `word-break: break-word` for long Thai words in tight containers

### Touch targets
- Buttons/links minimum 44×44px touch area on mobile
- Spacing between clickable items ≥ 8px

### Images & Media
- Fixed px dimensions → max-width: 100%
- Video/iframe → aspect-ratio wrapper

### Tables & Data
- Horizontal scroll wrapper for tables on mobile
- Or transform table to card layout on mobile

## Implementation approach
Use inline style + CSS custom properties. For responsive behavior, use one of:
1. `@media` queries in a `<style>` tag within the component (for complex cases)
2. CSS Grid `auto-fit`/`minmax` for natural reflow
3. `clamp()` for fluid typography: `fontSize: 'clamp(16px, 4vw, 24px)'`

## Process
1. Read the target file
2. List all responsive issues found
3. Fix them directly in the file
4. Note which breakpoints were addressed
