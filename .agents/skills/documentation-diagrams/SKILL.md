---
name: documentation-diagrams
description: Shared documentation and diagram skill for PlantUML, C4 diagrams, architecture decision records, service READMEs, API/event documentation, deployment diagrams, sequence diagrams, and runbook diagrams. Use when changing architecture, workflows, service boundaries, Kafka flows, APIs, deployments, or operational procedures.
---

# Documentation Diagrams

Use this skill whenever implementation changes need durable architecture or operational documentation.

## Required Documentation Types

- PlantUML or C4-PlantUML diagrams for context, containers, components, deployment, state, and sequence flows.
- ADRs for durable decisions with tradeoffs.
- Service documentation for run, test, deploy, observability, API, and event contracts.
- Runbooks for incident response, deploy, rollback, replay, and recovery.

## Diagram Rules

- Keep diagrams close to source docs and version-controlled.
- Prefer small, purpose-specific diagrams over one giant diagram.
- Include real service, topic, endpoint, namespace, and dependency names.
- Update diagrams in the same change as architecture, deployment, or public interface changes.
- Use ASCII/terminal-friendly PlantUML only when image rendering is impractical.
