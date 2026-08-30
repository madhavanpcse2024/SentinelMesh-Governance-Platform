# 🏛️ SentinelMesh Enterprise Architecture Specification

> **Platform**: SentinelMesh Multi-Agent Governance System  
> **Track**: The Fortified Enterprise Fleet  
> **Infrastructure Target**: Google Cloud Run & Vertex AI  

---

## 🎨 High-Resolution System Architecture Diagram

![SentinelMesh 10/10 Architecture Diagram](file:///d:/SentinelMesh-Governance-Platform/SentinelMesh_10of10_Architecture.png)

---

## ⚡ Interactive End-to-End Architecture Diagram

```mermaid
flowchart TD
  %% LAYER 1: FRONTEND & GATEWAY
  subgraph TIER1["1. INGRESS & IDENTITY GATEWAY"]
    UI["🖥️ React Control Room\n(Judge-facing UI & Auth)"]
    AUTH["🛡️ Auth Gateway\n(Trust-by-Header: x-user-role, x-user-id)"]
  end

  %% LAYER 2: ORCHESTRATOR & MEMORY
  subgraph ADK["2. GOOGLE ADK MULTI-AGENT ORCHESTRATOR (Vertex AI Gemini 3.5 Flash, Intent Router)"]
    RETRY["🔄 Bounded Retry Engine\n(Timeout 20s, 2 retries, Pydantic fallback)"]
    MEMORY["💾 Session Memory Bank\n(Firestore, cross-request persistence)"]
  end

  %% LAYER 3: SUB-AGENTS & POLICY TWIN
  subgraph SUBAGENTS["3. ISOLATED SPECIALIZED AGENTS"]
    COMP["📋 Compliance Monitor\n(Grant & IRB deadline risk scan)"]
    DATA["🔒 Data Access Agent\n(Scope check & Model Armor quarantine)"]
    REPORT["📊 Reporting Agent\n(4-part weekly synthesis & audit ledger)"]
  end

  TWIN["📜 Policy Twin\n(Read-only counterfactual explainer)"]

  %% LAYER 4: CLOUD INFRASTRUCTURE
  subgraph INFRA["4. GOOGLE CLOUD ENTERPRISE INFRASTRUCTURE"]
    RUN["☁️ Cloud Run\n(Serverless hosting, min-instances 0)"]
    DB[("🔥 Google Firestore\n(Session context, agent registry, rules)")]
    LOGS["🪵 Cloud Logging\n(OpenTelemetry structured audit log)"]
  end

  %% FLOW CONNECTIONS
  UI --> ADK
  AUTH --> ADK
  ADK --> COMP
  ADK --> DATA
  ADK --> REPORT
  DATA -.->|Dashed line = Read-only simulation, never grants access| TWIN
  COMP --> RUN
  DATA --> DB
  REPORT --> LOGS
  TWIN -.-> DB

  %% STYLING TO MATCH REFERENCE
  style TIER1 fill:#1e3a8a,stroke:#3b82f6,stroke-width:2px,color:#fff
  style UI fill:#1d4ed8,stroke:#60a5fa,color:#fff
  style AUTH fill:#1d4ed8,stroke:#60a5fa,color:#fff

  style ADK fill:#4c1d95,stroke:#8b5cf6,stroke-width:2px,color:#fff
  style RETRY fill:#374151,stroke:#6b7280,color:#fff
  style MEMORY fill:#374151,stroke:#6b7280,color:#fff

  style SUBAGENTS fill:#064e3b,stroke:#10b981,stroke-width:2px,color:#fff
  style COMP fill:#047857,stroke:#34d399,color:#fff
  style DATA fill:#047857,stroke:#34d399,color:#fff
  style REPORT fill:#047857,stroke:#34d399,color:#fff

  style TWIN fill:#7c2d12,stroke:#f97316,stroke-dasharray: 5 5,color:#fff

  style INFRA fill:#111827,stroke:#4b5563,stroke-width:2px,color:#fff
  style RUN fill:#374151,stroke:#9ca3af,color:#fff
  style DB fill:#374151,stroke:#9ca3af,color:#fff
  style LOGS fill:#374151,stroke:#9ca3af,color:#fff
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
