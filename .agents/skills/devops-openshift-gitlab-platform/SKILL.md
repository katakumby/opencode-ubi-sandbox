---
name: devops-openshift-gitlab-platform
description: DevOps workspace skill for Kubernetes, OpenShift, Docker, GitLab CI/CD, Ansible, Kafka platform operations, deployment automation, security scanning, observability, rollback, and release runbooks. Use when building or reviewing platform automation, pipelines, manifests, Helm/Kustomize overlays, OpenShift deployments, or operational procedures.
---

# DevOps OpenShift GitLab Platform

Use this skill as the DevOps role entrypoint. Prefer reproducible automation, least privilege, explicit rollback, and observable delivery.

## Core Stack

- Use Docker/BuildKit, Docker Compose, Trivy or Grype, Kubernetes, OpenShift `oc`, OpenShift Local/CRC when useful, Helm, Kustomize, Argo CD or Flux, GitLab CI/CD, GitLab Runner, `glab`, Ansible, ansible-lint, Ansible Vault, Terraform when present, Strimzi or Confluent Kafka operations, Prometheus, Grafana, Alertmanager, Loki/ELK, OpenTelemetry, SonarQube or Semgrep, External Secrets or Sealed Secrets, and cert-manager.
- Pair with `openshift-platform-ops`, `ansible-platform-automation`, `gitlab-openshift-delivery`, `kafka-platform-ops`, `release-rollback-runbooks`, `ci-quality-gates`, and `observability-security`.

## Delivery Workflow

1. Identify environments, cluster namespaces/projects, deploy targets, registry paths, secret sources, and promotion rules.
2. Build immutable images with pinned base images, non-root users, health checks, and vulnerability scanning.
3. Deploy through GitLab pipelines with build, test, security, package, deploy, smoke, and rollback stages.
4. Manage OpenShift manifests with Helm or Kustomize; avoid environment-specific copy-paste.
5. Document operational runbooks for deploy, rollback, certificate renewal, secret rotation, broker incidents, and alert response.

## Platform Guardrails

- Use least-privilege RBAC and OpenShift security context constraints.
- Never commit raw secrets; use Vault, External Secrets, Sealed Secrets, or GitLab protected CI variables.
- Set CPU/memory requests and limits, probes, disruption budgets where appropriate, and graceful termination.
- Capture deployment evidence: image digest, commit SHA, pipeline URL, manifest diff, rollout status, smoke result, and rollback command.
