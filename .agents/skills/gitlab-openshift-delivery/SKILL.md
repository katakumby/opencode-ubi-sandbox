---
name: gitlab-openshift-delivery
description: Custom DevOps skill for GitLab CI/CD delivery to OpenShift, Docker image builds, registry publishing, environment promotion, protected variables, deploy tokens, rollout smoke tests, artifacts, and rollback. Use when creating or changing `.gitlab-ci.yml` pipelines for OpenShift/Kubernetes applications.
---

# GitLab OpenShift Delivery

Use this skill for GitLab pipeline design and OpenShift deployment.

## Pipeline Stages

- `validate`: lint, format, config validation.
- `build`: compile and package application.
- `test`: unit, integration, contract, and smoke candidates.
- `secure`: SAST, dependency, secrets, container, and manifest scans.
- `image`: build, tag with commit SHA, push, and record digest.
- `deploy`: apply Helm/Kustomize manifests to target environment.
- `smoke`: health, route/API check, critical endpoint/UI flow, and rollback readiness.

## Rules

- Use protected variables for tokens and cluster credentials.
- Prefer image digests over mutable tags for deployment manifests.
- Keep production deploys gated and auditable.
- Save rollout logs, smoke outputs, test reports, and scan results as artifacts.
