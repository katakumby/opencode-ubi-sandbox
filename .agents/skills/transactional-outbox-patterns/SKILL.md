---
name: transactional-outbox-patterns
description: Custom backend skill for transactional outbox, reliable event publishing, database-to-Kafka consistency, retries, dead-letter handling, idempotent event processing, CDC publishing, and saga-safe microservice workflows. Use when a service must persist state and publish events reliably.
---

# Transactional Outbox Patterns

Use this skill when database state and Kafka publication must be consistent.

## Preferred Pattern

1. Persist aggregate state and outbox record in the same database transaction.
2. Publish outbox records asynchronously through polling or CDC.
3. Mark records published only after broker acknowledgement.
4. Retry transient failures and route poison messages to a dead-letter process.
5. Make consumers idempotent because at-least-once delivery is expected.

## Required Fields

- Event ID, aggregate ID, aggregate type, event type, schema version, payload, headers, correlation ID, created timestamp, published timestamp, retry count, and error details.

## Review Checklist

- No event is published before the transaction commits.
- Reprocessing the outbox does not duplicate business effects.
- Ordering requirements are documented per aggregate or topic key.
- Cleanup/retention policy preserves audit and replay needs.
