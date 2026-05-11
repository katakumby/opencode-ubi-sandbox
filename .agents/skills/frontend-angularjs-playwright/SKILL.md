---
name: frontend-angularjs-playwright
description: Front-end workspace skill for AngularJS 1.x, REST API integration, legacy AngularJS maintenance, migration-aware changes, Playwright UI tests, accessibility, and browser workflow validation. Use when editing AngularJS controllers, directives, services, routes, REST clients, forms, UI behavior, or frontend tests.
---

# Frontend AngularJS Playwright

Use this skill as the front-end role entrypoint. Assume AngularJS means Angular 1.x unless the repository proves it is Angular 2+.

## Core Stack

- Use project-pinned Node and npm/yarn/pnpm, AngularJS 1.x, ui-router or ngRoute, `$http`, promises, digest-cycle debugging, Karma/Jasmine or Jest, Playwright, OpenAPI client generation when present, MSW or WireMock mocks, axe accessibility checks, Lighthouse/Web Vitals, and Storybook when already established.
- Pair with `angularjs-maintenance`, `frontend-rest-contracts`, `angularjs-to-angular-migration-policy`, `accessibility-and-visual-regression`, `api-contracts-openapi`, and `ci-quality-gates`.

## Implementation Workflow

1. Determine whether the code is legacy AngularJS 1.x, hybrid ngUpgrade, or modern Angular.
2. Preserve existing module, service, directive, and route patterns unless the change is explicitly a migration.
3. Keep REST client behavior aligned with OpenAPI contracts and backend error shapes.
4. Make UI state deterministic: loading, empty, validation, error, success, disabled, and retry states.
5. Verify critical flows with Playwright and keep selectors accessible and stable.

## AngularJS Guardrails

- Avoid expanding `$rootScope` state or implicit global coupling.
- Prefer component-style directives for new UI inside AngularJS 1.x.
- Avoid manual DOM manipulation when AngularJS binding/directives can express the behavior.
- Use `$applyAsync` or `$timeout` intentionally when integrating external async code.
- Do not introduce modern Angular patterns into AngularJS code unless the project is already hybrid.
