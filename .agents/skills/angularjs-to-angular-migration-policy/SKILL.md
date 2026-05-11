---
name: angularjs-to-angular-migration-policy
description: Custom front-end skill for AngularJS 1.x to Angular migration policy, hybrid ngUpgrade strategy, vertical-slice migration, directive-to-component conversion, service modernization, routing migration, and safe boundaries between legacy and modern Angular code. Use when planning or implementing AngularJS modernization.
---

# AngularJS To Angular Migration Policy

Use this skill only for migration or modernization work. For ordinary AngularJS fixes, use `angularjs-maintenance`.

## Migration Strategy

- Choose big-bang only for very small apps.
- Prefer vertical slices or hybrid ngUpgrade for larger apps.
- Start with leaf components and shared services before core routing.
- Keep interop boundaries explicit and documented.
- Do not mix modern Angular idioms into legacy AngularJS files unless using a defined hybrid pattern.

## Conversion Rules

- Convert directives to components with explicit inputs/outputs.
- Replace `$scope` behavior with component state.
- Replace service patterns gradually while preserving API contracts.
- Use route-level migration boundaries when possible.
- Add Playwright smoke coverage before moving high-value flows.
