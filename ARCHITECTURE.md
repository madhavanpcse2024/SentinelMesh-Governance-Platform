# 🏛️ SentinelMesh Enterprise Architecture Specification

> **Platform**: SentinelMesh Multi-Agent Governance System  
> **Track**: The Fortified Enterprise Fleet  
> **Infrastructure Target**: Google Cloud Run & Vertex AI  

---

## 🎨 High-Resolution System Architecture Diagram

![SentinelMesh System Architecture Diagram](file:///d:/SentinelMesh-Governance-Platform/SentinelMesh_Architecture_Diagram.png)

---

## ⚡ Interactive Mermaid End-to-End Architecture

```mermaid
flowchart TD
  %% --------------------------------------------------
  %% LAYER 1: CLIENT & INGRESS GATEWAY
  %% --------------------------------------------------
  subgraph L1["1. CLIENT & SECURITY INGRESS GATEWAY"]
    UI["🖥️ React 19 Control Room UI\n(Glassmorphic Dark Theme)"]
    AUTH["🔐 Auth & Dynamic Identity System\n(Pre-seeded Roles: CSO, Auditor, PI)"]
    GATEWAY["🛡️ Trust-by-Header API Gateway\n(x-user-role, x-user-id, Rate Limiter)"]
  end

  %% --------------------------------------------------
  %% LAYER 2: ORCHESTRATION & REASONING ENGINE
  %% --------------------------------------------------
  subgraph L2["2. GOOGLE ADK MULTI-AGENT ORCHESTRATOR"]
    ORCH["⚡ Google ADK Orchestrator\n(Agent Development Kit Runtime)"]
    LLM["🧠 Vertex AI Gemini 3.5 Flash\n(System Prompt & Safety Guardrails)"]
    CIRCUIT["🔄 Self-Healing Circuit Breaker\n(Bounded Retry: Max 2, Fallback Default)"]
    POLICY["📜 Deterministic Policy Twin\n(Policy.py Counterfactual Engine)"]
  end

  %% --------------------------------------------------
  %% LAYER 3: ISOLATED SPECIALIZED AGENT FLEET
  %% --------------------------------------------------
  subgraph L3["3. ISOLATED SUB-AGENT FLEET (Scoped Tools)"]
    COMP_AGENT["📋 Compliance Monitor Agent\n(Tool: Grant & IRB Review DB)"]
    DATA_AGENT["🔒 Data Access Control Agent\n(Tool: Access Rules & Scopes)"]
    ARMOR["🚨 Model Armor Threat Defense\n(Inline Instruction Hijack Quarantine)"]
    REPORT_AGENT["📊 Executive Reporting Agent\n(Tool: Cross-Agent Intelligence Synthesis)"]
  end

  %% --------------------------------------------------
  %% LAYER 4: GOOGLE CLOUD INFRASTRUCTURE
  %% --------------------------------------------------
  subgraph L4["4. GOOGLE CLOUD ENTERPRISE INFRASTRUCTURE"]
    RUN["☁️ GCP Cloud Run Service\n(Min Instances: 0, Auto-scaling)"]
    FIRESTORE[("🔥 Google Firestore Memory Bank\n(session_memory & agent_registry)")]
    LOGGING["🪵 Google Cloud Logging\n(OpenTelemetry Structured Traces)"]
  end

  %% CONNECTIONS & FLOWS
  UI -->|HTTP / JSON + Identity Headers| GATEWAY
  AUTH -->|Inject Identity Context| GATEWAY
  GATEWAY -->|Authorized Governance Task| ORCH
  GATEWAY -->|Auditor Unauthorized Mutate| POLICY
  POLICY -->|Deny Action| UI

  ORCH <-->|Reasoning Loop| LLM
  ORCH -->|Invoke Sub-Agent| CIRCUIT
  CIRCUIT -->|Route Query| COMP_AGENT
  CIRCUIT -->|Route Query| DATA_AGENT
  CIRCUIT -->|Route Query| REPORT_AGENT

  DATA_AGENT <-->|Sanitize Prompt| ARMOR
  ARMOR -->|Quarantine Hijack| UI

  ORCH <-->|Read / Write Context| FIRESTORE
  ORCH -->|Stream Telemetry| LOGGING
  RUN --- L2
  RUN --- L4

  style L1 fill:#0f172a,stroke:#38bdf8,stroke-width:2px,color:#fff
  style L2 fill:#0f172a,stroke:#14b8a6,stroke-width:2px,color:#fff
  style L3 fill:#0f172a,stroke:#f59e0b,stroke-width:2px,color:#fff
  style L4 fill:#0f172a,stroke:#6366f1,stroke-width:2px,color:#fff
  style ARMOR fill:#7f1d1d,stroke:#f43f5e,stroke-width:2px,color:#fff
```

---

## 🔬 Deep-Dive Architectural Layer Breakdown

### **Layer 1: Security Ingress & Identity Gateway**
* **Trust-by-Header Middleware**: Every incoming request validates `x-user-role` and `x-user-id` HTTP headers before processing.
* **Role Gating**: `AUDITOR` profiles are restricted to read-only views; any attempt to trigger governance actions or mutate access policies yields an authentic **403 Forbidden** status response.

### **Layer 2: Google ADK Orchestrator & Gemini 3.5 Flash**
* **Google Agent Development Kit (ADK)**: Decoupled multi-agent orchestration runtime managing task classification, sub-agent invocation, and context delegation.
* **Vertex AI Integration**: Powered by **Gemini 3.5 Flash** for rapid, low-latency reasoning chains and structured Pydantic schema validation.
* **Self-Healing Circuit Breaker**: Bounded retry mechanism (maximum 2 retries) with schema correction prompts and safe default fallbacks to prevent infinite agent looping.

### **Layer 3: Isolated Sub-Agent Fleet & Model Armor**
* **Compliance Monitor Agent**: Inspects institutional grant renewal deadlines, IRB expiration schedules, and COG-24 compliance findings.
* **Data Access Agent**: Evaluates Principal Investigator (PI) dataset authorization boundaries.
* **Model Armor Threat Defense**: Scans incoming prompts for instruction overrides (e.g. *"ignore previous instructions"*), quarantines adversarial inputs, and renders an active **🚨 REQUEST QUARANTINED** alert payload.
* **Reporting Agent**: Synthesizes 4-part weekly governance digests and dispatches signed audit ledgers.

### **Layer 4: Google Cloud Infrastructure & Memory Bank**
* **GCP Cloud Run**: Containerized serverless deployment target (`https://sentinelmesh-gov-plane-7x9a3k-uc.a.run.app`) configured to scale to zero (`min-instances: 0`).
* **Google Firestore Memory Bank**: Dual-collection storage (`agent_registry` & `session_memory`) retaining cross-request persistent context.
* **Google Cloud Logging**: OpenTelemetry-compliant structured event stream tracking latency, token usage, and decision audit logs.

---

## 🎯 GEAP (Gemini Enterprise Agent Platform) 4-Pillar Alignment

| GEAP Pillar | Hackathon Requirement | SentinelMesh Implementation |
| :--- | :--- | :--- |
| **1. Agent Registry** | Discovery, scope declaration, and versioning catalog | Firestore `agent_registry` collection + `GET /registry` API endpoint. |
| **2. Agent Runtime & Memory Bank** | Asynchronous execution and persistent cross-session state | Google ADK `Runner` + Firestore `session_memory` context store. |
| **3. Security & Model Armor** | Zero-trust access control and inline prompt injection defense | `x-user-role` header validation + Model Armor threat quarantine scanner. |
| **4. Agent Observability** | Audit logging and reasoning chain traces | Cloud Logging telemetry stream + `/observability` live event tail. |
