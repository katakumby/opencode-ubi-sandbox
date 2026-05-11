---
name: flaky-test-triage
description: Custom tester skill for diagnosing flaky Java, Spring Boot, Kafka, REST, and Playwright tests. Use when tests pass on rerun, fail only in CI, depend on timing, leak state, collide on ports/topics, use brittle selectors, or have nondeterministic assertions.
---

# Flaky Test Triage

Use this skill when a failure is nondeterministic.

## Triage Order

1. Reproduce the smallest failing test with one worker or one fork.
2. Capture artifacts: logs, trace, screenshot, broker state, request/response, seed data, and timing.
3. Classify cause: shared state, timing/waiting, resource collision, selector ambiguity, environment drift, async completion, or data order.
4. Fix the root cause, not the symptom.
5. Re-run targeted tests repeatedly before broad regression.

## Fix Patterns

- Replace sleeps with deterministic waits or observable completion signals.
- Use unique test resources for ports, topics, schemas, files, users, and database rows.
- Use semantic Playwright locators and web-first assertions.
- Isolate Spring contexts and Testcontainers where shared state leaks.
- Treat retry-pass as failure evidence that needs investigation.
