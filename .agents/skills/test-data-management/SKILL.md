---
name: test-data-management
description: Custom tester skill for deterministic test data, seed strategies, fixtures, builders, database cleanup, Kafka topic setup, contract examples, Playwright auth state, and CI-safe parallel test isolation. Use when tests need repeatable data or isolation across unit, integration, contract, and E2E suites.
---

# Test Data Management

Use this skill to keep tests repeatable and parallel-safe.

## Data Rules

- Prefer builders and factories over copied fixture blobs.
- Seed only the data required by the test.
- Make IDs deterministic when assertions or replay depend on them.
- Clean up by transaction rollback, disposable containers, unique namespaces, or per-test prefixes.
- Avoid shared mutable global test data.

## Special Cases

- For Kafka, create unique topic names or consumer groups per suite when parallel runs can collide.
- For Playwright, use isolated storage state per user role and reset server-side state explicitly.
- For contract tests, store examples close to the contract and keep provider state setup minimal.
