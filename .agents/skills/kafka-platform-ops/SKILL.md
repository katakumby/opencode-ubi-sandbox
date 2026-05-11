---
name: kafka-platform-ops
description: Custom DevOps skill for Kafka platform operations, Strimzi or Confluent clusters, topics, ACLs, quotas, Schema Registry, Connect, broker health, consumer lag, partitioning, retention, backup, disaster recovery, and incident response. Use when operating Kafka infrastructure or reviewing Kafka deployment changes.
---

# Kafka Platform Ops

Use this skill for Kafka infrastructure and operational reliability.

## Operational Checks

- Broker health, under-replicated partitions, offline partitions, ISR shrink/expand, disk usage, controller stability, and request latency.
- Consumer lag, rebalance frequency, DLQ volume, retry volume, and throughput.
- Topic partition count, replication factor, retention, compaction, and ACLs.
- Schema Registry health and compatibility policy.
- Kafka Connect task status and connector offsets.

## Guardrails

- Production topics should use replication factor 3 or the platform-approved equivalent.
- Avoid unbounded topic creation and uncontrolled partition growth.
- Treat ACL, retention, compaction, and compatibility changes as production-risking operations.
- Keep broker, topic, and schema changes auditable through Git.
