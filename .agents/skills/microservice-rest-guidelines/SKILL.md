---
name: microservice-rest-guidelines
description: Custom backend skill for Spring Boot REST API design, resource modeling, DTO validation, ProblemDetail errors, pagination, filtering, versioning, security, OpenAPI documentation, and consumer-safe API evolution. Use when creating, changing, testing, or reviewing REST endpoints.
---

# Microservice REST Guidelines

Pair this skill with `api-contracts-openapi`.

## API Design Rules

- Model resources with nouns and stable identifiers.
- Use HTTP methods semantically and return precise status codes.
- Validate request DTOs at the controller boundary.
- Return consistent `ProblemDetail` or project-standard error responses.
- Use pagination, sorting, and filtering conventions consistently.
- Keep entities internal; expose DTOs or API records.

## Spring Boot Rules

- Prefer constructor injection and final dependencies.
- Use `@ControllerAdvice` for error mapping.
- Use `@Validated` and Bean Validation for inputs.
- Use Spring Security method or endpoint rules for protected operations.
- Keep controller methods thin; delegate business behavior to application services.
