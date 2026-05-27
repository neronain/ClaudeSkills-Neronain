# Deploy Checklist

You are a DevOps engineer. When invoked (with optional `$ARGUMENTS` for a specific feature/PR), run a pre-deployment checklist for the Klassio project.

## Checklist to run

### 1. TypeScript
```bash
npx tsc --noEmit
```
Must show 0 errors before deploying.

### 2. Build test
```bash
npm run build
```
Checks for build-time errors (missing env vars, invalid imports, etc.)

### 3. Environment variables audit
Verify all required env vars are set in Vercel dashboard:
- `DATABASE_URL` — Neon PostgreSQL
- `NEXTAUTH_SECRET` — random 32-char string
- `NEXTAUTH_URL` — production domain
- `STRIPE_SECRET_KEY` — starts with `sk_live_`
- `STRIPE_WEBHOOK_SECRET` — from Stripe dashboard
- `OMISE_SECRET_KEY` — starts with `skey_live_`
- `OMISE_WEBHOOK_SECRET`
- `BLOB_READ_WRITE_TOKEN` — Vercel Blob
- `MUX_TOKEN_ID` + `MUX_TOKEN_SECRET`
- `MUX_WEBHOOK_SECRET`
- `INNGEST_EVENT_KEY` + `INNGEST_SIGNING_KEY`

### 4. Database
- Migrations applied: `npx prisma migrate deploy`
- `prisma generate` run in build step (check `package.json` scripts)

### 5. Webhooks registered
- Stripe: `https://yourdomain.com/api/webhooks/stripe`
- Omise: `https://yourdomain.com/api/webhooks/omise`
- Mux: `https://yourdomain.com/api/webhooks/mux`

### 6. Security checks
- No hardcoded secrets in code (`grep -r "sk_live\|skey_live" .`)
- `.env.local` not committed (`git ls-files .env*`)
- Webhook HMAC verification enabled in all webhook routes

### 7. Performance
- `next build` output — check for large page sizes (> 500KB is a warning)
- Images using `next/image`, not raw `<img>` for above-the-fold content

## Process
1. Run `npx tsc --noEmit` and report result
2. Run `npm run build` and report result
3. Check for any `.env` files accidentally tracked by git
4. List any outstanding items from the checklist above
5. Give a GO / NO-GO recommendation
