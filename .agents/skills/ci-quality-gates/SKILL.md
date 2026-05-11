---
name: ci-quality-gates
description: Shared CI quality gate skill for GitLab pipelines, test stages, contract checks, Playwright smoke tests, security scans, dependency scans, container scans, code coverage, artifacts, deployment smoke tests, and release evidence. Use when creating or changing CI/CD workflows, merge gates, or verification strategy.
---

# CI Quality Gates

Use this skill whenever pipeline behavior, verification, or release criteria changes.

## Standard Pipeline Shape

1. Validate: format, lint, dependency lock checks, static config validation.
2. Build: compile/package application and produce immutable image or artifact.
3. Test: unit, slice, integration, contract, and targeted E2E smoke.
4. Secure: SAST, dependency scan, secrets scan, container scan, IaC/Kubernetes policy scan.
5. Package: tag image with commit SHA and publish SBOM when available.
6. Deploy: apply manifests through GitLab environment controls.
7. Smoke: verify service health, API readiness, critical UI/API flow, and rollback readiness.

## Gate Rules

- Pull requests or merge requests must run fast gates and targeted smoke checks.
- Full regression, load smoke, and deeper scans can run nightly or before release.
- Artifacts must include test reports, coverage, Playwright traces/screenshots on failure, scan results, image digest, and deployment logs.
- Manual production gates require rollback instructions and evidence from staging.
