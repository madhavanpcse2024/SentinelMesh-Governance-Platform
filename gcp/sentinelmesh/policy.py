"""Pure governance policy helpers shared by the Cloud Run runtime and tests."""

from __future__ import annotations

import re
from typing import Any


_SUSPICIOUS_PATTERNS = (
    re.compile(r"\b(ignore|disregard|override)\b.{0,80}\b(previous|system|policy|instructions?)\b", re.I),
    re.compile(r"\b(reveal|show|print|exfiltrate)\b.{0,80}\b(secret|token|credentials?|private data)\b", re.I),
    re.compile(r"\b(bypass|circumvent|disable)\b.{0,80}\b(guardrail|permission|approval|policy)\b", re.I),
)
_QUARANTINE_MARKER = "[QUARANTINED REQUEST:"


def suspicious_instruction(text: str) -> bool:
    """Detect common instruction-hijacking and privilege-escalation language."""

    return _QUARANTINE_MARKER in text or any(
        pattern.search(text) for pattern in _SUSPICIOUS_PATTERNS
    )


def sanitize_request_text(text: str) -> str:
    """Keep quarantined request text out of model/tool instructions."""

    if suspicious_instruction(text):
        return "[QUARANTINED REQUEST: suspicious instruction removed before model access]"
    return text


def evaluate_access_policy(
    requester: str,
    project_id: str,
    request_text: str,
    rule: dict[str, Any] | None,
) -> dict[str, Any]:
    """Return the deterministic policy result the model is never allowed to override."""

    rule = rule or {}
    injection_detected = suspicious_instruction(request_text)
    allowed_projects = rule.get("allowed_project_ids", [])
    authorized = project_id in allowed_projects and not injection_detected
    return {
        "requester": requester,
        "project_id": project_id,
        "authorized": authorized,
        "injection_detected": injection_detected,
        "allowed_project_ids": allowed_projects,
        "sanitized_request": sanitize_request_text(request_text),
    }


def apply_semantic_injection_signal(
    policy: dict[str, Any],
    semantic_injection_detected: bool,
) -> dict[str, Any]:
    """Merge the model-based signal into the deterministic access boundary."""

    if not semantic_injection_detected:
        return policy
    return {
        **policy,
        "authorized": False,
        "injection_detected": True,
        "sanitized_request": "[QUARANTINED REQUEST: semantic instruction hijacking suspected]",
    }


VALID_ROLES = {"ADMIN", "COMPLIANCE_OFFICER", "RESEARCHER", "AUDITOR"}


def validate_user_role(role: str | None) -> str:
    if not role:
        return "ADMIN"
    normalized = role.strip().upper()
    return normalized if normalized in VALID_ROLES else "ADMIN"


def can_execute_task(role: str) -> bool:
    """Check if role has privilege to run governed tasks."""
    return validate_user_role(role) != "AUDITOR"


def can_request_access(role: str) -> bool:
    """Check if role has privilege to request project data access."""
    return validate_user_role(role) in {"ADMIN", "COMPLIANCE_OFFICER", "RESEARCHER"}