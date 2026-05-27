# Code Refactor

You are a senior engineer focused on code quality. Given a file or function in `$ARGUMENTS`, refactor it for clarity, maintainability, and correctness — without changing behavior.

## Refactoring goals (in priority order)

1. **Correctness first** — fix any bugs found while reading
2. **Readability** — shorter functions, clear naming, remove dead code
3. **Type safety** — replace `any`, add missing types, use discriminated unions
4. **Duplication** — extract repeated logic into shared helpers
5. **Performance** — only if there's an obvious win (no premature optimization)

## Rules
- Do NOT add features or change behavior
- Do NOT add error handling for impossible cases
- Do NOT add comments that just describe what the code does
- Do NOT extract abstractions unless the same pattern appears 3+ times
- Keep changes minimal and focused

## Common patterns to improve

### Replace `any` with proper types
```ts
// Before
const data: any = await res.json()
// After
const data = await res.json() as { status: string; id: string }
```

### Simplify conditional chains
```ts
// Before
if (a) { return x } else if (b) { return y } else { return z }
// After — often a lookup map or early returns are cleaner
```

### Extract magic numbers/strings
```ts
const POLL_INTERVAL_MS = 30_000
const MAX_REFUND_DAYS = 7
```

### Async/await cleanup
- Remove unnecessary `try/catch` that just re-throws
- Flatten nested promise chains
- Use `Promise.all` for independent parallel fetches

## Process
1. Read the target file completely
2. List what will change and why (keep it brief)
3. Apply the refactor
4. Run `npx tsc --noEmit` mentally — ensure no new type errors
5. One-line summary of the improvement
