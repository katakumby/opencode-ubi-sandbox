---
name: accessibility-and-visual-regression
description: Custom front-end and tester skill for accessibility checks, semantic locators, keyboard flows, ARIA correctness, axe scans, visual regression, responsive layout verification, Playwright screenshots, and UI acceptance evidence. Use when changing UI behavior, forms, navigation, or visual layout.
---

# Accessibility And Visual Regression

Use this skill for UI changes that affect users.

## Accessibility Rules

- Prefer semantic HTML and accessible names over ARIA patches.
- Ensure controls are keyboard reachable and have visible focus.
- Use labels for form controls and useful error messages.
- Check contrast, heading structure, landmark regions, and dialog focus behavior.
- Use Playwright locators that reflect accessibility expectations.

## Visual Regression Rules

- Capture screenshots for critical states: default, loading, empty, error, success, and responsive breakpoints.
- Avoid brittle pixel-only assertions unless the project already uses them.
- Pair screenshots with functional assertions.
- Store artifacts in CI for failed visual/UI tests.
