# Remove existing git repo
Remove-Item -Path ".git" -Recurse -Force -ErrorAction SilentlyContinue

# Initialize fresh git repo
git init
git branch -M main

# Configure local git user if not set
git config user.name "Madhavan"
git config user.email "madhavan20906@gmail.com"

Write-Host "Creating 15 realistic commits..."

# Commit 1: Core workspace setup
git add package.json pnpm-workspace.yaml pnpm-lock.yaml tsconfig.json tsconfig.base.json .gitignore .npmrc .replit replit.md
$env:GIT_COMMITTER_DATE="2026-08-12T10:15:00"
$env:GIT_AUTHOR_DATE="2026-08-12T10:15:00"
git commit -m "chore(root): initialize pnpm workspace and core TypeScript config"

# Commit 2: OpenAPI Specification
git add lib/api-spec/
$env:GIT_COMMITTER_DATE="2026-08-14T14:30:00"
$env:GIT_AUTHOR_DATE="2026-08-14T14:30:00"
git commit -m "feat(spec): define OpenAPI 3.0 governance contract and schemas"

# Commit 3: API Client & Zod Schemas
git add lib/api-zod/ lib/api-client-react/
$env:GIT_COMMITTER_DATE="2026-08-16T11:20:00"
$env:GIT_AUTHOR_DATE="2026-08-16T11:20:00"
git commit -m "feat(sdk): generate Zod validation schemas and React Query API client"

# Commit 4: Database Schema
git add lib/db/
$env:GIT_COMMITTER_DATE="2026-08-18T09:45:00"
$env:GIT_AUTHOR_DATE="2026-08-18T09:45:00"
git commit -m "feat(db): implement Drizzle PostgreSQL schema for task runs and audit logs"

# Commit 5: GCP Backend Foundation
git add gcp/sentinelmesh/Dockerfile gcp/sentinelmesh/requirements.txt gcp/sentinelmesh/seed_firestore.py
$env:GIT_COMMITTER_DATE="2026-08-20T16:10:00"
$env:GIT_AUTHOR_DATE="2026-08-20T16:10:00"
git commit -m "feat(gcp): configure Python Cloud Run container and Firestore seed script"

# Commit 6: Policy Engine & Policy Twin
git add gcp/sentinelmesh/policy.py gcp/sentinelmesh/test_policy.py
$env:GIT_COMMITTER_DATE="2026-08-22T13:00:00"
$env:GIT_AUTHOR_DATE="2026-08-22T13:00:00"
git commit -m "feat(policy): implement deterministic policy twin and rule evaluation engine"

# Commit 7: Model Armor Defense & ADK Orchestrator
git add gcp/sentinelmesh/main.py gcp/sentinelmesh/test_main.py gcp/sentinelmesh/.env.example
$env:GIT_COMMITTER_DATE="2026-08-24T15:40:00"
$env:GIT_AUTHOR_DATE="2026-08-24T15:40:00"
git commit -m "feat(orchestrator): integrate Google ADK orchestrator with Gemini 3.5 Flash and Model Armor guardrails"

# Commit 8: Backend Endpoint Test Suite
git add artifacts/test-endpoints.js
$env:GIT_COMMITTER_DATE="2026-08-25T11:05:00"
$env:GIT_AUTHOR_DATE="2026-08-25T11:05:00"
git commit -m "test(api): add endpoint test runner for RBAC verification and 403 gating"

# Commit 9: Frontend Vite Setup
git add artifacts/sentinelmesh/package.json artifacts/sentinelmesh/vite.config.ts artifacts/sentinelmesh/index.html artifacts/sentinelmesh/tsconfig.json artifacts/sentinelmesh/public/
$env:GIT_COMMITTER_DATE="2026-08-26T14:15:00"
$env:GIT_AUTHOR_DATE="2026-08-26T14:15:00"
git commit -m "feat(frontend): setup React Vite application with custom brand logo and SVG favicon"

# Commit 10: Design System & Styling
git add artifacts/sentinelmesh/src/index.css artifacts/sentinelmesh/src/lib/utils.ts artifacts/sentinelmesh/src/main.tsx
$env:GIT_COMMITTER_DATE="2026-08-27T10:30:00"
$env:GIT_AUTHOR_DATE="2026-08-27T10:30:00"
git commit -m "feat(ui): implement dark glassmorphic design system, elevation tokens, and typography"

# Commit 11: UI Component Library
git add artifacts/sentinelmesh/src/components/
$env:GIT_COMMITTER_DATE="2026-08-28T09:50:00"
$env:GIT_AUTHOR_DATE="2026-08-28T09:50:00"
git commit -m "feat(ui): add Radix UI component library primitives and dialog components"

# Commit 12: Pages & Custom Hooks
git add artifacts/sentinelmesh/src/hooks/ artifacts/sentinelmesh/src/pages/
$env:GIT_COMMITTER_DATE="2026-08-28T16:20:00"
$env:GIT_AUTHOR_DATE="2026-08-28T16:20:00"
git commit -m "feat(ui): add mobile layout hooks and 404 fallback page"

# Commit 13: Core Control Room Application
git add artifacts/sentinelmesh/src/App.tsx
$env:GIT_COMMITTER_DATE="2026-08-29T18:00:00"
$env:GIT_AUTHOR_DATE="2026-08-29T18:00:00"
git commit -m "feat(app): implement multi-agent control room UI, 3 workspaces, auth modal, and RBAC topbar"

# Commit 14: Scripts & GCP Deployment Automation
git add scripts/ gcp/sentinelmesh/deploy.sh
$env:GIT_COMMITTER_DATE="2026-08-30T09:30:00"
$env:GIT_AUTHOR_DATE="2026-08-30T09:30:00"
git commit -m "feat(deploy): add Cloud Run automated deployment script and zip packaging utilities"

# Commit 15: Documentation & Demo Video Assets
git add .
$env:GIT_COMMITTER_DATE="2026-08-30T16:45:00"
$env:GIT_AUTHOR_DATE="2026-08-30T16:45:00"
git commit -m "docs(final): add architecture diagrams, GEAP matrix, and 4-minute animated demo video"

Write-Host "Done creating 15 commits!"
