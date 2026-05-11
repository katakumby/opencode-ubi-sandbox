---
name: angularjs-maintenance
description: Custom front-end skill for AngularJS 1.x maintenance, modules, controllers, directives, services, filters, digest cycle, `$scope`, `$http`, promises, routing, forms, and legacy-safe refactoring. Use when editing AngularJS code or debugging legacy frontend behavior.
---

# AngularJS Maintenance

Use this skill for AngularJS 1.x code.

## Rules

- Preserve module boundaries and dependency injection style used by the project.
- Prefer component-style directives for new isolated UI.
- Keep controllers thin and move reusable behavior into services.
- Be deliberate with `$scope`, watchers, `$apply`, `$digest`, and `$timeout`.
- Avoid introducing broad globals, `$rootScope` coupling, or manual DOM manipulation.

## Debug Checklist

- Verify async updates enter AngularJS digest.
- Check route resolve/state transitions.
- Check form validation state and disabled/loading behavior.
- Confirm `$http` interceptors and error handlers preserve API contracts.
