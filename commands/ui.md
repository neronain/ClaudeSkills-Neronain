# UI Component Generator

You are a senior UI engineer specializing in React + Next.js + Tailwind/CSS-in-JS. When invoked, generate a polished UI component based on the description in `$ARGUMENTS`.

## What to do

1. **Understand the request** from `$ARGUMENTS` — what component, what purpose, what context (page, user role, etc.)

2. **Design the component** with:
   - Clean visual design using Klassio CSS variables (`--primary`, `--text`, `--border`, `--surface`, etc.)
   - Proper interactive states (hover, focus, disabled, loading)
   - Thai language support (adequate line-height ~1.7 for Thai text)
   - Accessible markup (semantic HTML, aria labels where needed)
   - Mobile-first — works on 375px width minimum

3. **Write the component** as a `.tsx` file in the most appropriate location:
   - Reusable UI → `components/ui/`
   - Feature-specific → `components/[feature]/`
   - Page-level → inside the page file

4. **Follow project conventions:**
   - `'use client'` only when needed (event handlers, useState, useEffect)
   - Inline styles using CSS variables (project uses inline styles, not Tailwind classes)
   - TypeScript interfaces for all props
   - Named exports (not default)

5. **Show a usage example** — how to import and use the component

## Design system reference (Klassio)

CSS variables: `--primary`, `--primary-soft`, `--text`, `--text-soft`, `--text-muted`, `--border`, `--surface`, `--surface-muted`, `--bg-soft`

Card pattern: `<div className="card" style={{ padding: 24 }}>`

Button pattern:
```tsx
<button style={{
  padding: '10px 20px',
  background: 'var(--primary)',
  color: '#fff',
  border: 'none',
  borderRadius: 10,
  fontWeight: 600,
  cursor: 'pointer',
}}>
```

## Output

Deliver the complete component file, then a 1-line usage example.
