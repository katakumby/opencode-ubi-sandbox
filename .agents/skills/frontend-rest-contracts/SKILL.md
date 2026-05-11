---
name: frontend-rest-contracts
description: Custom front-end skill for REST API consumption, OpenAPI-aligned clients, AngularJS `$http` services, error handling, loading states, retries, mocks, and consumer-side contract expectations. Use when connecting frontend behavior to backend REST APIs or updating API clients.
---

# Frontend REST Contracts

Pair this skill with `api-contracts-openapi`.

## Client Rules

- Keep API calls in services, not controllers or directives.
- Align request/response shapes with OpenAPI or documented backend contracts.
- Handle loading, empty, validation error, authorization error, server error, network error, and retry states.
- Avoid duplicating backend validation rules unless needed for user experience.
- Use generated clients only when the repository already supports them or the change explicitly introduces them.

## Test Rules

- Mock APIs at the service boundary for unit tests.
- Use Playwright or integration tests for critical user journeys.
- Keep error fixtures realistic and aligned with backend `ProblemDetail` or project-standard errors.
