---
name: kafka-replay-idempotency-testing
description: Custom tester skill for Kafka replay, duplicate delivery, idempotent consumers, offset reset scenarios, event ordering, poison-message recovery, and state reconciliation tests. Use when validating that event-driven services survive reprocessing and at-least-once delivery.
---

# Kafka Replay Idempotency Testing

Use this skill to prove consumers are safe under replay and duplicate delivery.

## Test Scenarios

- Process the same event twice and assert one business effect.
- Replay a topic range from earliest and assert final state remains correct.
- Deliver events with missing optional fields from older schemas.
- Send poison messages and assert retry/DLQ handling.
- Restart the consumer mid-processing and assert no lost or duplicated business effect.

## Evidence

- Record input events, keys, offsets, consumer group, final state, retry/DLQ messages, and relevant logs with correlation IDs.
