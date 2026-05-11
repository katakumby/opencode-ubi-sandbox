---
name: tester-java-playwright-contracts
description: Tester workspace skill for Java, Spring Boot, Kafka, REST API, Playwright, Testcontainers, contract testing, E2E smoke testing, and CI quality evidence. Use when planning, writing, reviewing, or debugging automated tests for backend services, event-driven flows, APIs, and browser workflows.
---

# Tester Java Playwright Contracts

Use this skill as the tester role entrypoint. Optimize for fast feedback, trustworthy failure signals, and evidence that can run in CI.

## Core Stack

- Use JDK 17/21, Maven or Gradle, JUnit 5, AssertJ, Mockito, Spring Boot Test, MockMvc or WebTestClient, REST Assured or Karate, WireMock, Testcontainers, Pact or Spring Cloud Contract, Playwright, JaCoCo, Allure or HTML/JUnit reports, and CI artifacts.
- Pair with `event-driven-test-strategy`, `test-data-management`, `flaky-test-triage`, `kafka-replay-idempotency-testing`, `api-contracts-openapi`, `ci-quality-gates`, and `observability-security`.

## Test Strategy

1. Map the behavior to the narrowest useful test type: unit, slice, integration, contract, E2E, smoke, or load smoke.
2. Keep E2E thin and focused on critical user outcomes; push business coverage down to unit, slice, integration, and contract tests.
3. Use Testcontainers for Kafka, databases, and infrastructure-sensitive integration tests.
4. Treat retries as diagnostic evidence, not a fix for flaky tests.
5. Capture artifacts on failure: logs, screenshots, traces, reports, broker/topic snapshots, and request/response samples.

## Acceptance Rules

- API behavior is checked against OpenAPI or explicit contract expectations.
- Kafka behavior validates schema compatibility, keying, ordering assumptions, retries, idempotency, and dead-letter behavior.
- Playwright locators prefer role, label, visible text, then `data-testid`.
- Tests must be independent, parallel-safe, and order-independent unless explicitly marked otherwise.
- CI reports must make failures actionable without relying on local reproduction.
