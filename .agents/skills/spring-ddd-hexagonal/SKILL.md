---
name: spring-ddd-hexagonal
description: Custom backend skill for Spring Boot domain-driven design, hexagonal architecture, bounded contexts, aggregates, value objects, repositories, application services, adapters, and anti-corruption layers. Use when designing or refactoring backend domain modules, complex business rules, persistence boundaries, or service integration boundaries.
---

# Spring DDD Hexagonal

Use this skill for complex business domains. Do not force DDD onto simple CRUD.

## Structure

- Domain: aggregates, entities, value objects, domain services, domain events, specifications.
- Application: use cases, command/query handlers, transactions, orchestration, ports.
- Infrastructure: JPA, Kafka, REST clients, file systems, external service adapters.
- API: controllers, request/response DTOs, validation, error mapping.

## Rules

- Keep domain classes free of Spring, JPA, Kafka, HTTP, and framework annotations unless the repository already standardizes otherwise.
- Persist aggregate roots through repository ports; do not let controllers call repositories directly.
- Reference other aggregates by ID unless strong consistency and invariants require otherwise.
- Put cross-aggregate orchestration in application services or sagas, not entities.
- Use anti-corruption layers for external systems and foreign domain models.
