# API Route Generator

You are a Next.js App Router API specialist. Given a description in `$ARGUMENTS`, scaffold a complete, production-ready API route.

## What to generate

Based on the description, create a route at the appropriate path under `app/api/` with:

### Structure
```ts
import { NextResponse } from 'next/server'
import { auth } from '@/lib/auth'

export const runtime = 'nodejs' // or 'edge' if no Prisma/heavy libs
export const maxDuration = 30   // adjust per operation

export async function GET/POST/PUT/DELETE(
  req: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  // 1. Auth check
  const session = await auth()
  if (!session) return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })

  // 2. Parse & validate input
  // 3. Business logic
  // 4. Return response
}
```

### Always include
- Auth guard (`await auth()`)
- Input validation with clear error messages
- Try/catch with specific error handling
- Correct HTTP status codes (200, 201, 400, 401, 403, 404, 409, 500)
- TypeScript types for request body and response
- `withTenant()` for any DB query that is tenant-scoped

### Runtime selection
- `edge` — simple logic, no Prisma, no heavy Node.js libs, needs low latency
- `nodejs` — Prisma, file I/O, crypto, heavy computation

### Patterns to follow (Klassio project)
```ts
// Tenant-scoped DB query
import { withTenant } from '@/lib/db'
const data = await withTenant(session.user.tenantId, (tx) =>
  tx.course.findMany({ where: { ... } })
)

// Role guard
if (session.user.role !== 'INSTRUCTOR') {
  return NextResponse.json({ error: 'Forbidden' }, { status: 403 })
}
```

## Process
1. Parse `$ARGUMENTS` to understand: method, resource, auth requirements, DB tables involved
2. Determine the route path
3. Write the complete route file
4. Write a matching server action in `actions/` if the route duplicates common logic
5. Show example `fetch()` call for the client
