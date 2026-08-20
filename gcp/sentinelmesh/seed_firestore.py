"""Seed the Firestore collections used by SentinelMesh.

Run once after enabling Firestore:
  python seed_firestore.py
"""

from __future__ import annotations

import os
from google.cloud import firestore

project = os.environ.get("GCP_PROJECT_ID") or os.environ.get("GOOGLE_CLOUD_PROJECT")
if not project:
    raise RuntimeError("Set GCP_PROJECT_ID first")

db = firestore.Client(project=project)

agents = [
    {
        "id": "compliance-monitor",
        "name": "Compliance Monitor",
        "version": "1.4.0",
        "declared_scope": "Grant deadlines, IRB reviews, institutional compliance",
        "declared_tools": ["firestore.compliance_items", "gemini.flash"],
        "status": "active",
        "owner": "Research Operations",
    },
    {
        "id": "data-access",
        "name": "Data Access",
        "version": "1.2.2",
        "declared_scope": "Project-scoped data access decisions",
        "declared_tools": ["firestore.access_rules", "firestore.access_log", "gemini.flash"],
        "status": "active",
        "owner": "Security & Privacy",
    },
    {
        "id": "reporting",
        "name": "Reporting",
        "version": "1.0.8",
        "declared_scope": "Cross-agent weekly governance synthesis",
        "declared_tools": ["firestore.orchestrator_events", "firestore.compliance_items", "gemini.flash"],
        "status": "active",
        "owner": "Chief Research Office",
    },
]

for agent in agents:
    db.collection("agent_registry").document(agent["id"]).set(agent)

items = [
    ("IRB-2026-041", "Annual renewal — wearable cognition study", "Dr. Priya Nair", "2026-09-04", "COG-24-118", "at-risk"),
    ("NSF-POW-882", "NSF progress report", "Dr. Elena Rossi", "2026-09-12", "BIO-25-019", "on-track"),
    ("DATA-RET-207", "Restricted dataset retention review", "Dr. Marcus Chen", "2026-08-28", "NEU-23-077", "overdue"),
    ("NIH-COI-114", "Annual conflict disclosure", "Dr. Amina Yusuf", "2026-09-18", "IMM-26-004", "on-track"),
    ("IRB-2026-038", "Adverse event response", "Dr. Samuel Okafor", "2026-09-02", "PED-25-204", "at-risk"),
    ("DOE-ACCESS-061", "Annual controlled-data attestation", "Dr. Lina Haddad", "2026-09-23", "MAT-24-091", "on-track"),
    ("GRANT-CLOSE-332", "Grant closeout inventory", "Dr. Noah Williams", "2026-10-01", "ENV-22-031", "on-track"),
    ("DATA-USE-145", "Data use agreement renewal", "Dr. Mei Tan", "2026-09-07", "GEN-26-012", "at-risk"),
]

for item_id, title, owner, due_date, project_id, risk_level in items:
    db.collection("compliance_items").document(item_id).set(
        {
            "item_id": item_id,
            "title": title,
            "owner": owner,
            "due_date": due_date,
            "project_id": project_id,
            "risk_level": risk_level,
            "summary": "Seeded demo item for the campus research lab governance scenario.",
            "recommended_action": "Review owner readiness and complete the next required filing.",
        }
    )

for requester, projects in {
    "Dr. Priya Nair": ["COG-24-118", "PED-25-204"],
    "Dr. Elena Rossi": ["BIO-25-019", "ENV-22-031"],
    "Dr. Marcus Chen": ["NEU-23-077"],
    "Dr. Amina Yusuf": ["IMM-26-004", "GEN-26-012"],
}.items():
    db.collection("access_rules").document(requester).set({"requester": requester, "allowed_project_ids": projects})

print("Seeded compliance_items and access_rules.")