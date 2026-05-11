---
name: backend-java-spring-eda
description: Backend Developer workspace skill for Java, Spring Boot, REST APIs, Kafka, Avro, event-driven microservices, domain-driven design, PlantUML architecture diagrams, and Kubernetes/OpenShift readiness. Use when implementing or reviewing backend services, domain models, Kafka producers/consumers, REST contracts, schema changes, or deployment-ready Spring Boot microservices.
---

# Backend Java Spring EDA

Use this skill as the backend role entrypoint. Prefer the repository's existing conventions first, then apply these standards.

## Core Stack

- Use Java 17 or 21, Spring Boot 3.x, Maven or Gradle, Spring MVC/WebFlux, Spring Security, Spring Data, Spring Kafka, Spring Cloud Stream, Micrometer, and OpenTelemetry.
- Use Kafka CLI tools, `kcat`, Avro tooling, Schema Registry clients, OpenAPI/Swagger tooling, AsyncAPI for event catalogs, PlantUML or C4-PlantUML, Docker, Testcontainers, `kubectl`, `oc`, Helm, and Kustomize.
- Pair with `java-springboot`, `spring-ddd-hexagonal`, `kafka-avro-contracts`, `microservice-rest-guidelines`, `transactional-outbox-patterns`, `api-contracts-openapi`, `observability-security`, `ci-quality-gates`, and `documentation-diagrams`.

## Architecture Workflow

1. Identify the bounded context, aggregate roots, REST resources, commands, queries, events, and external dependencies.
2. Keep domain logic inside domain/application layers; keep Spring, JPA, Kafka, and HTTP adapters outside the domain model.
3. Define REST contracts with OpenAPI and event contracts with Avro plus topic ownership metadata before changing public interfaces.
4. Use immutable DTOs/records where practical, validation annotations at API boundaries, and consistent `ProblemDetail` errors.
5. Add observability at the same time as behavior: correlation IDs, structured logs, metrics, traces, and health probes.

## Event-Driven Rules

- Name events in past tense and version them explicitly.
- Use stable event keys that preserve aggregate ordering.
- Design consumers as idempotent and retry-safe.
- Use dead-letter topics, retry topics, or outbox processing for failure paths.
- Use Avro compatibility checks before publishing schema changes.

## Delivery Checklist

- Unit tests cover domain rules without Spring context.
- Slice tests cover controllers, persistence, serialization, and security rules.
- Integration tests use Testcontainers for Kafka, database, and critical infrastructure.
- OpenAPI, Avro schemas, topic catalog entries, and PlantUML diagrams are updated with behavior changes.
- Kubernetes/OpenShift readiness includes liveness/readiness probes, resource requests/limits, config/secrets separation, and graceful shutdown.
