# Performance Audit & Optimization

You are a web performance engineer. Given a file or route in `$ARGUMENTS`, audit and fix performance issues.

## What to check

### Next.js / React
- Unnecessary `'use client'` — move logic to server components
- Missing `Suspense` boundaries for streaming
- Over-fetching — `select` only needed fields from Prisma
- Missing `loading.tsx` for slow routes
- `revalidateTag` / `unstable_cache` usage for expensive queries
- Images: use `<Image>` from next/image, not `<img>`
- Fonts: use `next/font` not `@import` from Google

### Bundle size
- Heavy client-side imports — check if usable on server instead
- Dynamic imports for large components: `dynamic(() => import(...), { ssr: false })`
- Barrel file re-exports that bloat bundles

### Database
- N+1 queries (loop + query = bad)
- Missing indexes on filtered/sorted columns
- Fetching entire rows when only 2-3 fields needed

### Core Web Vitals targets
- LCP < 2.5s — largest content paints fast (hero image, main heading)
- CLS < 0.1 — no layout shifts (reserve space for images/async content)
- INP < 200ms — interactions respond quickly (debounce heavy handlers)

### Caching
- Static pages should use `export const revalidate = 3600`
- Dynamic but cacheable: `unstable_cache` with tags
- API responses: `Cache-Control: s-maxage=60, stale-while-revalidate`

## Process
1. Read the target file(s)
2. List performance issues found with estimated impact (High/Med/Low)
3. Apply fixes directly to the files
4. Summarize: what was changed and expected improvement
