---
name: event-driven-test-strategy
description: Custom tester skill for testing event-driven microservices, Kafka producers and consumers, idempotency, retries, dead-letter topics, schema compatibility, outbox behavior, replay, ordering, and distributed workflow assertions. Use when designing or debugging tests for EDA systems.
---

# Event Driven Test Strategy

Use this skill for Kafka and asynchronous workflows.

## Test Layers

- Unit: domain events, handlers, mapping, idempotency decisions.
- Integration: Kafka broker, Schema Registry if available, database, outbox, retry/DLQ paths through Testcontainers.
- Contract: Avro compatibility and producer/consumer expectations.
- Workflow: multi-service scenario with deterministic seed data and observable completion criteria.

## Assertions

- Event is published with expected key, schema, headers, and payload.
- Consumer handles duplicates and out-of-order safe cases according to contract.
- Retry and DLQ behavior is deterministic and visible.
- Replay does not corrupt state.
- Correlation IDs link logs, metrics, and traces across services.
