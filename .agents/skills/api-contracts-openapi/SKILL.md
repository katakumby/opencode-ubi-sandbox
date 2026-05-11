---
name: api-contracts-openapi
description: Shared API governance skill for REST API design, OpenAPI specifications, API versioning, backwards compatibility, contract testing, generated clients, and request/response examples. Use when creating or changing HTTP endpoints, DTOs, clients, tests, mocks, or API documentation.
---

# API Contracts OpenAPI

Use this skill whenever an HTTP API surface changes.

## Required Artifacts

- OpenAPI document for public and service-to-service REST APIs.
- Request and response schemas, examples, error responses, auth requirements, pagination/filtering conventions, and deprecation metadata.
- Contract tests or schema validation for high-value consumers.

## Contract Workflow

1. Identify consumers, resources, operations, auth scopes, and compatibility constraints.
2. Update or create OpenAPI before or alongside implementation.
3. Use stable `operationId` values and reusable schema components.
4. Define all expected success and error status codes.
5. Validate generated clients, mocks, and tests against the same contract.

## Compatibility Rules

- Safe: add optional response fields, add new endpoints, add optional request fields with defaults.
- Risky: rename fields, change types, tighten validation, remove enum values, remove endpoints, or alter error shapes.
- Breaking changes require versioning, migration notes, and consumer coordination.
