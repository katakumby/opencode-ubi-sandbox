# ADR-001: Use Keycloak Token Exchange at the API Gateway

## Status

Accepted

## Date

2026-05-30

## Context

The platform receives API requests from clients authenticated by multiple
identity provider systems owned by different organizations. External systems are
expected to include partner Keycloak realms and ADFS.

The organization already runs Keycloak and wants one internal token format that
all microservices can validate consistently. The architecture is event-driven,
and services should stay focused on their domain logic instead of implementing
provider-specific OAuth, OIDC, ADFS, or external Keycloak validation.

The API Gateway is the natural boundary for accepting external bearer tokens.
It can authenticate to the organization Keycloak realm as a confidential client,
exchange or assert external tokens, and forward only internal Keycloak tokens to
downstream services.

## Decision

Use the existing organization Keycloak realm as the internal security token
service for external OAuth/OIDC identities.

The API Gateway will:

- Accept external bearer tokens from trusted external IdPs.
- Exchange or assert them through the organization Keycloak token endpoint.
- Request internal access tokens scoped to the target microservice audience.
- Forward only the internal access token to downstream microservices.
- Strip external tokens and inbound identity headers before forwarding.

Microservices will:

- Trust only the organization Keycloak issuer.
- Validate internal access tokens for signature, issuer, audience, expiration,
  and required scopes.
- Use mapped provenance claims for audit when external identity context is
  needed.
- Avoid direct validation of partner Keycloak or ADFS tokens.

The primary implementation pattern is Keycloak Standard Token Exchange V2 plus
JWT Authorization Grant. This aligns with the current supported Keycloak
replacement for external-to-internal token exchange.

Legacy external-to-internal token exchange may be used only as a temporary
migration fallback. It is preview and deprecated in Keycloak, disabled by
default, and expected to be removed in a future version.

ADFS integrations must provide signed OIDC/JWT tokens or assertions. SAML is
not part of the gateway token exchange design.

## Alternatives Considered

### Each microservice validates every external IdP

Pros:

- Gateway remains simpler.
- Services can make provider-specific authorization decisions directly.

Cons:

- Duplicates external IdP validation logic across services.
- Couples every service to partner Keycloak and ADFS details.
- Makes onboarding or removing an external organization expensive.
- Increases risk of inconsistent issuer, audience, signature, or claim checks.

Rejected because it spreads the security boundary across the whole platform.

### Dedicated standalone security token service

Pros:

- Full control over exchange policy and token shape.
- Can hide Keycloak-specific behavior behind a custom service.

Cons:

- Introduces another critical security component to build and operate.
- Duplicates capabilities already available in Keycloak.
- Requires custom implementation of token validation, signing, rotation,
  revocation behavior, audit, and administration.

Rejected because the organization already operates Keycloak and can centralize
the trust relationship there.

### Legacy Keycloak external-to-internal token exchange as the primary pattern

Pros:

- Directly models "external token in, internal token out."
- Simpler first-hop gateway request.

Cons:

- Preview and deprecated in Keycloak.
- Disabled by default.
- Requires older fine-grained admin permission behavior.
- Carries removal risk in future Keycloak upgrades.

Rejected as the primary pattern. It remains acceptable only as a controlled
short-term fallback.

## Consequences

- The organization Keycloak realm becomes the central trust boundary for inbound
  external identities.
- Gateway client credentials become high-value secrets and must be stored in a
  secret manager, rotated, and monitored.
- External identity providers must be configured and reviewed in the internal
  realm before tokens from that organization are accepted.
- User account linking is required so external subjects map to intended
  internal Keycloak users.
- Microservice authorization becomes simpler and more consistent because all
  services validate the same internal issuer and claim model.
- Access tokens should be short-lived because revocation of an exchanged access
  token does not automatically revoke every downstream access token chain.
- Event payloads must carry selected identity metadata rather than raw bearer
  tokens.

## Implementation Notes

- Gateway client id: `api-gateway-token-exchanger`.
- Token endpoint: `/realms/{realm}/protocol/openid-connect/token`.
- External IdP aliases: `partner-keycloak-{org}` and `adfs-{org}`.
- Internal audiences: one client or audience per microservice or service group.
- Required grants:
  - `urn:ietf:params:oauth:grant-type:jwt-bearer`.
  - `urn:ietf:params:oauth:grant-type:token-exchange`.
- Required provenance claims in internal tokens:
  - `identity_provider`.
  - `external_issuer`.
  - `external_subject`.

See [Keycloak Token Exchange at the API Gateway](../security/keycloak-token-exchange.md)
for usage guidance and sequence diagrams.
