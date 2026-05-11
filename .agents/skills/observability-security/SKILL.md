---
name: observability-security
description: Shared observability and security baseline skill for structured logging, correlation IDs, metrics, tracing, dashboards, alerts, OWASP checks, secrets handling, secure containers, Kubernetes/OpenShift hardening, and audit-ready evidence. Use when implementing production behavior, reviewing risk, adding services, configuring deployments, or defining quality gates.
---

# Observability Security

Use this skill whenever code or platform changes affect production behavior.

## Observability Baseline

- Use structured logs with timestamp, level, service, environment, trace ID, span ID, correlation ID, user or actor where safe, and domain identifiers.
- Propagate correlation IDs through REST calls, Kafka headers, and logs.
- Expose useful metrics for request rate, latency, errors, Kafka lag, retries, DLQs, business throughput, and resource health.
- Use OpenTelemetry-compatible tracing for cross-service flows.
- Provide dashboards and alerts for symptoms, not only causes.

## Security Baseline

- Check Java for SQL injection, XXE, insecure deserialization, weak crypto, SSRF, auth/JWT mistakes, and secret leakage.
- Check TypeScript/AngularJS for XSS, unsafe HTML, weak auth storage, CSRF exposure, and dependency risks.
- Check Docker/Kubernetes/OpenShift for non-root execution, pinned images, RBAC least privilege, restricted security contexts, resource limits, secret handling, and network exposure.
- Treat secrets, credentials, tokens, and production data as sensitive; never log them.

## Evidence Checklist

- Logs, metrics, traces, dashboard or alert links, security scan output, dependency scan output, container scan output, and deployment smoke result are available for release review.
