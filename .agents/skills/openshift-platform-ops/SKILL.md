---
name: openshift-platform-ops
description: Custom DevOps skill for OpenShift platform operations, `oc` workflows, projects/namespaces, routes, deployments, security context constraints, RBAC, image streams, rollout diagnostics, and cluster-safe application delivery. Use when deploying, debugging, or reviewing workloads on OpenShift.
---

# OpenShift Platform Ops

Use this skill for OpenShift-specific platform work.

## Workflow

1. Identify project, service account, route, deployment, config, secret, and image source.
2. Check `oc status`, events, pods, rollout history, logs, probes, and resource pressure.
3. Validate security context constraints, non-root execution, mounted secrets/configs, and route/TLS configuration.
4. Use rollout status and deployment revisions for safe promotion and rollback.

## Guardrails

- Do not grant broad cluster roles for application workloads.
- Prefer namespace-scoped permissions and service accounts.
- Keep image digests traceable to GitLab pipeline artifacts.
- Document `oc` commands used for diagnosis and rollback in runbooks.
