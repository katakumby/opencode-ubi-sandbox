---
name: ansible-platform-automation
description: Custom DevOps skill for Ansible automation, idempotent playbooks, roles, inventories, group_vars/host_vars, Ansible Vault, ansible-lint, Jinja2 templates, platform provisioning, and repeatable operational tasks. Use when creating or reviewing Ansible-based automation.
---

# Ansible Platform Automation

Use this skill for repeatable infrastructure and operational automation.

## Rules

- Write idempotent tasks and use modules instead of shell commands where possible.
- Organize reusable logic into roles.
- Put environment-specific values in inventory, `group_vars`, or `host_vars`.
- Store sensitive values in Ansible Vault or an approved secret manager.
- Validate with `ansible-lint` and check mode where practical.

## Review Checklist

- Tasks have clear names and predictable change reporting.
- Templates are deterministic and avoid hidden environment assumptions.
- Variables have defaults or documented required inputs.
- Rollback or recovery is documented for risky operations.
