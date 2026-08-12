# SentinelMesh

SentinelMesh is a governance control plane for a campus research lab's multi-agent fleet, routing compliance, data-access, and reporting work with scoped permissions, durable context, and visible recovery traces.

## Run & Operate

- `pnpm --filter @workspace/api-server run dev` — run the API server (port 5000)
- `pnpm run typecheck` — full typecheck across all packages
- `pnpm run build` — typecheck + build all packages
- `pnpm --filter @workspace/api-spec run codegen` — regenerate API hooks and Zod schemas from the OpenAPI spec
- `pnpm --filter @workspace/db run push` — push DB schema changes (dev only)
- Required env: `DATABASE_URL` — Postgres connection string
- Preview API routes are served under `/api`; the hackathon deployment target lives in `gcp/sentinelmesh`.

## Stack

- pnpm workspaces, Node.js 24, TypeScript 5.9
- API: Express 5
- DB: PostgreSQL + Drizzle ORM
- Validation: Zod (`zod/v4`), `drizzle-zod`
- API codegen: Orval (from OpenAPI spec)
- Build: esbuild (CJS bundle)

## Where things live

- `artifacts/sentinelmesh` — deployable React/Vite judge-facing control plane.
- `artifacts/api-server/src/routes/governance.ts` — local preview adapter with registry, routing, access, activity, and recovery flows.
- `lib/api-spec/openapi.yaml` — source of truth for the shared API contract.
- `gcp/sentinelmesh` — production-oriented Cloud Run service using Google ADK, Gemini via Vertex AI, Firestore, and Cloud Logging.

## Architecture decisions

- Exactly three registered sub-agents are exposed: Compliance Monitor, Data Access, and Reporting.
- Failure recovery is evidence-first: bounded retries, schema validation, and a visible safe fallback.
- The Replit preview is intentionally a minimal control plane; the GCP Python service is the submission deployment target.
- The demo video is reference material only and is not bundled into the application.

## Product

The control plane exposes fleet health, the registered agent contracts, compliance risk, governed task execution, access decisions with injection detection, weekly cross-agent reporting, observability metrics, and session context lookup.

## User preferences

- Keep the application focused on the Fortified Enterprise Fleet requirements; do not add extra sub-agents or a built-out frontend beyond the judgeable control plane.

## Gotchas

- Run `pnpm --filter @workspace/api-spec run codegen` after changing `lib/api-spec/openapi.yaml`.
- Cloud Run deployment requires a real GCP project, Firestore, Vertex AI access, and `SENTINELMESH_API_KEY`; Replit preview hosting is not deployment proof for the hackathon.

## Pointers

- See the `pnpm-workspace` skill for workspace structure, TypeScript setup, and package details
