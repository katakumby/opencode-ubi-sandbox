---
name: kafka-avro-schema-registry
description: Shared Kafka governance skill for Avro schemas, Schema Registry, topic catalogs, producer/consumer contracts, compatibility modes, event keys, retries, dead-letter topics, and Kafka event evolution. Use when creating or changing Kafka topics, events, schemas, consumers, producers, or stream-processing flows.
---

# Kafka Avro Schema Registry

Use this skill whenever Kafka event contracts or topic behavior changes.

## Required Artifacts

- Avro schema with namespace, record name, field docs, defaults where needed, and semantic version notes.
- Topic catalog entry with owner, purpose, key, value schema, partitions, retention, compaction, PII classification, producer services, consumer services, and DLQ/retry policy.
- Schema Registry compatibility decision and evidence from compatibility checks.

## Event Contract Workflow

1. Identify event purpose, aggregate key, ordering needs, consumers, retention, and replay expectations.
2. Choose topic naming and partitioning strategy before writing producer code.
3. Define Avro schema with backwards-compatible evolution by default.
4. Implement idempotent producer and consumer behavior.
5. Test schema compatibility, serialization, retries, DLQ behavior, and replay.

## Evolution Rules

- Prefer backward compatibility for consumer safety.
- Add fields with defaults when old producers or old events must remain readable.
- Do not remove or rename fields without migration and consumer coordination.
- Document semantic changes even when the schema remains technically compatible.
