---
name: release-rollback-runbooks
description: Custom DevOps skill for release runbooks, deployment evidence, smoke tests, rollback procedures, incident response, release readiness, and post-deploy verification across GitLab, OpenShift, Spring Boot, Kafka, and frontend applications. Use when preparing or reviewing a release.
---

# Release Rollback Runbooks

Use this skill before production or shared-environment releases.

## Runbook Contents

- Release version, commit SHA, image digest, target environment, deploy pipeline, and owner.
- Prechecks: health, capacity, dependency state, migrations, topic/schema compatibility, and feature flags.
- Deploy steps and expected signals.
- Smoke tests and acceptance checks.
- Rollback command and rollback verification.
- Known risks, monitoring links, alert expectations, and escalation contacts.

## Rollback Rules

- Rollback must be tested or at least command-validated before production.
- Database and schema migrations need explicit backward compatibility notes.
- Kafka schema and event changes need consumer compatibility and replay notes.
- Capture evidence even when rollback is not needed.
