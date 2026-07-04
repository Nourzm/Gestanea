# analyze-lab Edge Function

Server-side proxy for AI lab-result extraction + pregnancy-aware interpretation.
The AI key stays here as a secret; the Flutter app calls this function with the
user's Supabase session. **The provider is switchable** — start free on Gemini,
flip to Claude later without any app changes.

## Choose a provider

Set `LAB_AI_PROVIDER`:

| Value | AI | Key secret | Cost | Notes |
|---|---|---|---|---|
| `gemini` (default) | Gemini 2.0 Flash | `GEMINI_API_KEY` | **Free tier** | No credit card — key from aistudio.google.com. Free tier may use submitted data to improve Google products, so it's best for testing/MVP rather than sensitive production health data. |
| `anthropic` | Claude (Opus 4.8 default) | `ANTHROPIC_API_KEY` | Pay-per-use | Best quality + privacy (not used for training). |

Both return the identical JSON shape, so switching is purely a secret change.

## Deploy

From `gestanea/` (Supabase CLI logged in + linked):

```bash
# 1. Rate-limit table
supabase db push

# 2A. FREE path — Gemini (default provider, no card needed)
supabase secrets set GEMINI_API_KEY=AIza...        # from aistudio.google.com
#   (LAB_AI_PROVIDER defaults to "gemini"; optionally: supabase secrets set GEMINI_MODEL=gemini-2.0-flash)

# 2B. PAID path — Claude (when you're ready)
#   supabase secrets set LAB_AI_PROVIDER=anthropic
#   supabase secrets set ANTHROPIC_API_KEY=sk-ant-...
#   (optional: supabase secrets set LAB_AI_MODEL=claude-sonnet-4-6  # cheaper than the opus default)

# 3. Deploy
supabase functions deploy analyze-lab
```

`SUPABASE_URL`, `SUPABASE_ANON_KEY`, and `SUPABASE_SERVICE_ROLE_KEY` are injected
by the runtime — don't set them. JWT verification is on by default, so only
signed-in users can call it. Daily per-user cap: `LAB_AI_DAILY_LIMIT` (default 20).

## Switch providers later

Just change the secret and redeploy — no app rebuild needed:

```bash
supabase secrets set LAB_AI_PROVIDER=anthropic
supabase secrets set ANTHROPIC_API_KEY=sk-ant-...
supabase functions deploy analyze-lab
```

## Test

```bash
curl -i -X POST "$SUPABASE_URL/functions/v1/analyze-lab" \
  -H "Authorization: Bearer <a user access token>" \
  -H "content-type: application/json" \
  -d '{"ocrText":"Hemoglobin 10.2 g/dL (11.0-14.0)","context":{"week":28,"trimester":"2nd Trimester"},"locale":"en"}'
```
