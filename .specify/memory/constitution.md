<!-- Sync Impact Report
Version change: (template/initial) → 0.1.0
Modified principles:
1) I. Tooling-First
2) II. CLI Interfaces
3) III. Test-First for Contracts
4) IV. Integration Coverage
5) V. Observability & Safety
6) VI. Versioning & Compatibility
Added sections:
- Delivery Constraints
- Quality Bar
- Workflow
Templates requiring updates:
- ❗No template changes applied in this step (plan/spec/tasks templates remain generic).
Follow-up TODOs:
- None
-->

# Browser Automation Constitution
<!-- Project constitution for this workspace (browser + automation tooling). -->

## Core Principles

### I. Tooling-First
Every change must produce a usable automation unit (script/library) that can be run and verified.
No “research-only” code: if it can’t be invoked, it doesn’t count as done.

### II. CLI Interfaces
Expose automation via a deterministic command interface (CLI).
Prefer JSON for machine output plus a human-readable mode for logs.
Errors must go to `stderr` with actionable messages.

### III. Test-First for Contracts
Before implementing behavior that depends on external systems (browser, MCP, network), define a contract in tests.
Tests must validate input/output shape and error handling; only after failing tests exist do we implement.

### IV. Integration Coverage
Changes affecting:
- browser automation flows,
- MCP wiring,
- API integrations,
must include integration tests or a reproducible verification script.
If full tests aren’t feasible, provide a step-by-step verification procedure.

### V. Observability & Safety
Automation must be debuggable:
- structured logs for key steps,
- timestamps for network/browser operations,
- clear failure reasons.
Never log secrets (tokens, passwords, gateway keys).

### VI. Versioning & Compatibility
When behavior changes impact CLI outputs or protocols, bump the constitution version (MINOR for new rules, MAJOR for breaking policy changes) and document migration guidance.

## Delivery Constraints
All new automation must fit the existing environment model:
- tool commands must be wired through `opencode.json` (when they are MCP tools),
- environment variables must be referenced as `{env:VAR_NAME}` in configs,
- no secret material must be committed to the repository.

## Quality Bar
Rule changes must be provable: either via tests, or via a reproducible `verification` procedure checked into the repo (e.g., a short script or doc).

## Workflow
1. Propose the change as a small, runnable unit (script/library/command).
2. Add/adjust tests that capture expected behavior and failure modes.
3. Verify via integration test or reproducible verification steps.
4. Submit for review with: what changed, why, and how to verify.

## Governance
This constitution supersedes other local practices.

Amendments:
- must be documented in the updated constitution file,
- require a clear rationale and migration/verification guidance when rules affect existing workflows,
- must bump **Version** according to semantic versioning (MAJOR/MINOR/PATCH).

Compliance expectations:
- every PR must demonstrate either tests or a reproducible verification procedure,
- reviewers must check that secrets are not leaked into logs/configs.

**Version**: 0.1.0 | **Ratified**: 2026-04-11 | **Last Amended**: 2026-04-11
<!-- Initial ratification for this repository constitution. -->
