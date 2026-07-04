// Supabase Edge Function: analyze-lab
//
// Server-side proxy for lab-result extraction + pregnancy-aware interpretation.
// The AI provider is switchable via the LAB_AI_PROVIDER secret:
//   - "gemini"    (default) → Google Gemini free tier (GEMINI_API_KEY)
//   - "anthropic"           → Claude (ANTHROPIC_API_KEY)
// The provider key lives here as a secret and never reaches the Flutter client.
// Requests are authenticated with the caller's Supabase JWT (verify_jwt on by
// default) and rate-limited per user per day. Both providers return the SAME
// JSON shape (see the schemas below), so the app doesn't care which is used.
//
// Request body (JSON):
//   { imageBase64?, mediaType?, ocrText?, context?: {week,trimester,conditions,priorResults}, locale }

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const PROVIDER = (Deno.env.get("LAB_AI_PROVIDER") ?? "gemini").toLowerCase();
const GEMINI_MODEL = Deno.env.get("GEMINI_MODEL") ?? "gemini-2.0-flash";
const ANTHROPIC_MODEL = Deno.env.get("LAB_AI_MODEL") ?? "claude-opus-4-8";
// OpenRouter routes to many models via its own upstream accounts (free `:free`
// variants need no card and work regardless of the caller's region).
const OPENROUTER_MODEL =
  Deno.env.get("OPENROUTER_MODEL") ?? "google/gemini-2.0-flash-exp:free";
const DAILY_LIMIT = Number(Deno.env.get("LAB_AI_DAILY_LIMIT") ?? "20");

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

// --- Result shape, expressed for each provider's structured-output dialect ---

// Anthropic / JSON-Schema flavor.
const ANTHROPIC_SCHEMA = {
  type: "object",
  additionalProperties: false,
  properties: {
    tests: {
      type: "array",
      items: {
        type: "object",
        additionalProperties: false,
        properties: {
          testName: { type: "string" },
          value: { type: "string" },
          unit: { type: "string" },
          referenceRange: { type: "string" },
          status: {
            type: "string",
            enum: ["normal", "low", "high", "borderline", "unknown"],
          },
          explanation: { type: "string" },
        },
        required: [
          "testName",
          "value",
          "unit",
          "referenceRange",
          "status",
          "explanation",
        ],
      },
    },
    overallSummary: { type: "string" },
    redFlag: { type: "boolean" },
    redFlagMessage: { type: "string" },
    guidance: { type: "array", items: { type: "string" } },
    disclaimer: { type: "string" },
  },
  required: [
    "tests",
    "overallSummary",
    "redFlag",
    "redFlagMessage",
    "guidance",
    "disclaimer",
  ],
};

// Gemini uses uppercase OpenAPI-subset types and no additionalProperties.
const GEMINI_SCHEMA = {
  type: "OBJECT",
  properties: {
    tests: {
      type: "ARRAY",
      items: {
        type: "OBJECT",
        properties: {
          testName: { type: "STRING" },
          value: { type: "STRING" },
          unit: { type: "STRING" },
          referenceRange: { type: "STRING" },
          status: {
            type: "STRING",
            enum: ["normal", "low", "high", "borderline", "unknown"],
          },
          explanation: { type: "STRING" },
        },
        required: [
          "testName",
          "value",
          "unit",
          "referenceRange",
          "status",
          "explanation",
        ],
      },
    },
    overallSummary: { type: "STRING" },
    redFlag: { type: "BOOLEAN" },
    redFlagMessage: { type: "STRING" },
    guidance: { type: "ARRAY", items: { type: "STRING" } },
    disclaimer: { type: "STRING" },
  },
  required: [
    "tests",
    "overallSummary",
    "redFlag",
    "redFlagMessage",
    "guidance",
    "disclaimer",
  ],
};

function systemPrompt(locale: string): string {
  const langName =
    locale === "fr" ? "French" : locale === "ar" ? "Arabic" : "English";
  return [
    "You are a careful medical-information assistant inside a pregnancy-care app.",
    "You read laboratory reports and explain them to an expecting mother in plain, supportive language.",
    "",
    "Given a lab report image and/or OCR text plus the mother's pregnancy context:",
    "1. EXTRACT every test you can identify: test name, value, unit, and the lab's printed reference range.",
    "2. For each test, decide a status (normal / low / high / borderline / unknown) considering pregnancy-adjusted ranges where they differ.",
    "3. Write a short, plain-language explanation per test of what it measures and what this result suggests at this stage of pregnancy.",
    "4. Provide an overall summary and concrete, non-prescriptive lifestyle guidance.",
    "",
    "CRITICAL SAFETY RULES:",
    "- This is EDUCATIONAL information, NOT a diagnosis and NOT medical advice.",
    "- NEVER recommend specific medications, dosages, or stopping/starting any drug.",
    "- If any value suggests a potentially serious condition (severe anemia, very high blood sugar, preeclampsia markers, infection), set redFlag=true and write redFlagMessage telling her to contact her doctor or midwife promptly (or seek urgent care if severe). Otherwise redFlag=false and redFlagMessage=\"\".",
    "- Always fill the disclaimer field reminding her this is not a substitute for her healthcare provider.",
    "- If you cannot read a value, use status \"unknown\" rather than guessing.",
    "",
    `Write ALL human-readable text in ${langName}.`,
    "Return ONLY the structured JSON object.",
  ].join("\n");
}

function buildUserText(body: Record<string, unknown>): string {
  const ctx = (body.context ?? {}) as Record<string, unknown>;
  const ocrText = (body.ocrText as string | undefined)?.trim();
  const parts: string[] = ["Please analyze this lab report."];
  if (ctx.week != null) parts.push(`Pregnancy week: ${ctx.week}.`);
  if (ctx.trimester) parts.push(`Trimester: ${ctx.trimester}.`);
  if (Array.isArray(ctx.conditions) && ctx.conditions.length > 0) {
    parts.push(`Known conditions: ${(ctx.conditions as string[]).join(", ")}.`);
  }
  if (ctx.priorResults) parts.push(`Prior results context: ${ctx.priorResults}`);
  if (ocrText) {
    parts.push(
      "\nOCR text extracted on-device (may contain errors — prefer the image if both are present):\n" +
        ocrText,
    );
  }
  return parts.join(" ");
}

// --- Provider calls: both return the parsed result object or throw ---

async function callGemini(
  body: Record<string, unknown>,
  locale: string,
): Promise<unknown> {
  const key = Deno.env.get("GEMINI_API_KEY");
  if (!key) throw new Error("GEMINI_API_KEY not set");

  const parts: unknown[] = [];
  const imageBase64 = body.imageBase64 as string | undefined;
  const mediaType = body.mediaType as string | undefined;
  if (imageBase64 && mediaType) {
    parts.push({ inlineData: { mimeType: mediaType, data: imageBase64 } });
  }
  parts.push({ text: buildUserText(body) });

  const url =
    `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent?key=${key}`;
  const res = await fetch(url, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({
      systemInstruction: { parts: [{ text: systemPrompt(locale) }] },
      contents: [{ role: "user", parts }],
      generationConfig: {
        responseMimeType: "application/json",
        responseSchema: GEMINI_SCHEMA,
        temperature: 0.2,
      },
    }),
  });
  if (!res.ok) {
    throw new Error(`gemini ${res.status}: ${await res.text()}`);
  }
  const data = await res.json();
  const text = data?.candidates?.[0]?.content?.parts?.[0]?.text;
  if (!text) throw new Error("gemini: empty response");
  return JSON.parse(text);
}

async function callAnthropic(
  body: Record<string, unknown>,
  locale: string,
): Promise<unknown> {
  const key = Deno.env.get("ANTHROPIC_API_KEY");
  if (!key) throw new Error("ANTHROPIC_API_KEY not set");

  const content: unknown[] = [];
  const imageBase64 = body.imageBase64 as string | undefined;
  const mediaType = body.mediaType as string | undefined;
  if (imageBase64 && mediaType) {
    content.push(
      mediaType === "application/pdf"
        ? {
            type: "document",
            source: { type: "base64", media_type: mediaType, data: imageBase64 },
          }
        : {
            type: "image",
            source: { type: "base64", media_type: mediaType, data: imageBase64 },
          },
    );
  }
  content.push({ type: "text", text: buildUserText(body) });

  const res = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "content-type": "application/json",
      "x-api-key": key,
      "anthropic-version": "2023-06-01",
    },
    body: JSON.stringify({
      model: ANTHROPIC_MODEL,
      max_tokens: 4000,
      thinking: { type: "adaptive" },
      output_config: {
        effort: "high",
        format: { type: "json_schema", schema: ANTHROPIC_SCHEMA },
      },
      system: systemPrompt(locale),
      messages: [{ role: "user", content }],
    }),
  });
  if (!res.ok) {
    throw new Error(`anthropic ${res.status}: ${await res.text()}`);
  }
  const data = await res.json();
  const textBlock = (data.content ?? []).find(
    (b: { type: string }) => b.type === "text",
  );
  if (!textBlock?.text) throw new Error("anthropic: empty response");
  return JSON.parse(textBlock.text);
}

// Plain-text description of the required JSON object, for providers (like the
// OpenRouter free models) that don't enforce a JSON schema server-side.
function jsonShapeHint(): string {
  return [
    "Return ONLY a JSON object (no markdown, no code fences) with EXACTLY these keys:",
    '{"tests":[{"testName":string,"value":string,"unit":string,"referenceRange":string,"status":"normal"|"low"|"high"|"borderline"|"unknown","explanation":string}],',
    '"overallSummary":string,"redFlag":boolean,"redFlagMessage":string,"guidance":[string],"disclaimer":string}',
  ].join("\n");
}

// Tolerant JSON parse: strips ``` fences and pulls the outermost { ... } so a
// model that adds prose around the JSON still parses.
function parseJsonLoose(text: string): unknown {
  try {
    return JSON.parse(text);
  } catch (_) {
    const start = text.indexOf("{");
    const end = text.lastIndexOf("}");
    if (start >= 0 && end > start) {
      return JSON.parse(text.slice(start, end + 1));
    }
    throw new Error("could not parse JSON from model output");
  }
}

async function callOpenRouter(
  body: Record<string, unknown>,
  locale: string,
): Promise<unknown> {
  const key = Deno.env.get("OPENROUTER_API_KEY");
  if (!key) throw new Error("OPENROUTER_API_KEY not set");

  const content: unknown[] = [];
  const imageBase64 = body.imageBase64 as string | undefined;
  const mediaType = body.mediaType as string | undefined;
  // OpenRouter chat models take images as data-URI image_url (no PDFs — those
  // fall back to the OCR text already included in buildUserText).
  if (imageBase64 && mediaType && mediaType !== "application/pdf") {
    content.push({
      type: "image_url",
      image_url: { url: `data:${mediaType};base64,${imageBase64}` },
    });
  }
  content.push({ type: "text", text: buildUserText(body) });

  const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
    method: "POST",
    headers: {
      "content-type": "application/json",
      "authorization": `Bearer ${key}`,
      "HTTP-Referer": "https://gestanea.app",
      "X-Title": "Gestanea",
    },
    body: JSON.stringify({
      model: OPENROUTER_MODEL,
      messages: [
        { role: "system", content: `${systemPrompt(locale)}\n\n${jsonShapeHint()}` },
        { role: "user", content },
      ],
      response_format: { type: "json_object" },
      temperature: 0.2,
    }),
  });
  if (!res.ok) throw new Error(`openrouter ${res.status}: ${await res.text()}`);
  const data = await res.json();
  const text = data?.choices?.[0]?.message?.content;
  if (!text) throw new Error("openrouter: empty response");
  return parseJsonLoose(typeof text === "string" ? text : JSON.stringify(text));
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") return json({ error: "Method not allowed" }, 405);

  // --- Identify the caller ---
  // The app authenticates users locally (not via Supabase Auth), so requests
  // arrive with the anon key and no Supabase user. We still resolve a user id
  // when a real Supabase session is present (future-proofing), but fall back to
  // "anonymous" otherwise rather than rejecting. verify_jwt (on by default)
  // already ensures the caller holds a valid project key.
  const authHeader = req.headers.get("Authorization") ?? "";
  const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY")!;
  let userId = "anonymous";
  try {
    const userClient = createClient(supabaseUrl, anonKey, {
      global: { headers: { Authorization: authHeader } },
    });
    const { data: userData } = await userClient.auth.getUser();
    if (userData?.user) userId = userData.user.id;
  } catch (_) {
    // no Supabase session — proceed as anonymous
  }

  // --- Per-user daily rate limit (service-role bypasses RLS) ---
  // Best-effort: if the ai_lab_usage table isn't there yet (migration not
  // applied), skip limiting rather than failing — so a first deploy works with
  // just the provider secret, no DB step required.
  const serviceClient = createClient(
    supabaseUrl,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );
  try {
    const since = new Date();
    since.setHours(0, 0, 0, 0);
    const { count, error } = await serviceClient
      .from("ai_lab_usage")
      .select("id", { count: "exact", head: true })
      .eq("user_id", userId)
      .gte("created_at", since.toISOString());
    if (!error && (count ?? 0) >= DAILY_LIMIT) {
      return json(
        { error: "rate_limited", message: "Daily AI limit reached" },
        429,
      );
    }
  } catch (_) {
    // table missing or query failed — don't block the request
  }

  let body: Record<string, unknown>;
  try {
    body = await req.json();
  } catch {
    return json({ error: "Invalid JSON body" }, 400);
  }
  const locale = (body.locale as string) ?? "en";

  let result: unknown;
  try {
    result = PROVIDER === "anthropic"
      ? await callAnthropic(body, locale)
      : PROVIDER === "openrouter"
      ? await callOpenRouter(body, locale)
      : await callGemini(body, locale);
  } catch (e) {
    return json({ error: "upstream_error", detail: String(e) }, 502);
  }

  // Record usage (best-effort; ignored if the table doesn't exist).
  try {
    await serviceClient.from("ai_lab_usage").insert({ user_id: userId });
  } catch (_) {
    // no-op
  }

  const model = PROVIDER === "anthropic"
    ? ANTHROPIC_MODEL
    : PROVIDER === "openrouter"
    ? OPENROUTER_MODEL
    : GEMINI_MODEL;
  return json({ result, provider: PROVIDER, model }, 200);
});

function json(obj: unknown, status: number): Response {
  return new Response(JSON.stringify(obj), {
    status,
    headers: { ...corsHeaders, "content-type": "application/json" },
  });
}
