---
name: kafka-avro-contracts
description: Custom backend skill for Kafka Avro producer and consumer contracts, event payload design, schema evolution, topic metadata, compatibility testing, serialization, and Java/Spring Kafka integration. Use when implementing Kafka events, changing Avro schemas, or reviewing event-driven backend changes.
---

# Kafka Avro Contracts

Pair this skill with `kafka-avro-schema-registry`.

## Implementation Rules

- Generate or compile Avro classes from versioned schemas; avoid hand-maintained duplicate DTOs.
- Configure serializers/deserializers explicitly and keep Schema Registry URL externalized.
- Use stable event keys and headers for correlation ID, causation ID, trace context, schema/version hints, and producer service.
- Validate schema compatibility in CI before producer code is merged.
- Document consumer expectations for replay, ordering, missing fields, and duplicate messages.

## Review Checklist

- Schema has defaults for newly added fields.
- Consumer is idempotent and retry-safe.
- Failed messages have an explicit retry/DLQ strategy.
- Event does not carry unnecessary large payloads or sensitive data.
- Tests prove serialization, deserialization, compatibility, and at least one realistic consume path.
