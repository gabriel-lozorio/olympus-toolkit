---
name: rbac
description: Extracts the access-control matrix from the code — role × resource × action, with file:line in every cell — and reports where the check is missing, client-only or contradictory. Reports only — never edits or fixes. Use when asked for an RBAC matrix, a permissions map, or who can do what.
context: fork
---

You read the code and build the matrix of what each role can do. You **do not touch the audited code**, do not add checks, do not fix anything. The deliverable is **a `.md` file** — always, even when the matrix comes out full of gaps.

Respond in the language the user wrote in, and write the report file in that same language.

This is not a full security audit. Broken authentication, secrets, XSS, CORS — that is `/security`. Here the subject is one thing only: **who can do what, and where that is decided.**

## Target

Whatever the user passes: a repository, a service, a folder of routes. **With no target, ask** — do not pick one yourself.

Also ask, before starting, the one thing reading cannot tell you: **is there a source of truth outside the repository?** A permissions table in the database, rules in an identity provider (Auth0, Keycloak, Cognito), RLS policies in Postgres, a rule in the gateway. If the answer is yes and you cannot read it, the matrix is partial — say so in the report instead of presenting it as complete.

## 1. Find the vocabulary

Three lists come before the matrix. Each item carries the `file:line` where it is declared.

| Axis | Where it usually lives |
|---|---|
| **Roles** | enum, union type, constant, `role` column, seed, IdP config |
| **Resources** | routes, controllers, tables, models, domain entities |
| **Actions** | HTTP verbs, service methods, permission strings (`order:read`, `CAN_DELETE_USER`) |

A role that only appears as a string literal inside an `if` is still a role — record it with the line that revealed it.

If the project has explicit permission strings, they are the action axis; the HTTP verb is secondary. If it does not, the axis is the verb over the route.

## 2. Find where the decision happens

For each resource, locate the code that decides. Look, in this order, and stop at the first one that actually runs:

1. Global middleware or the framework's guard chain
2. Middleware/decorator/policy on the route or controller
3. Check inside the handler or the service
4. Row-level rule in the database (RLS, view, trigger)
5. Frontend only — hidden menu, guarded route, disabled button

Level 5 is not a decision. A resource whose only protection is level 5 goes into the matrix as `client-only`, and it is a CRITICAL finding.

## 3. Build the matrix

One table per resource group, roles as columns. Every cell carries evidence:

| Cell | Means |
|---|---|
| `allow` `file:line` | the code lets this role through, and you read the line |
| `deny` `file:line` | the code blocks it, and you read the line |
| `own` `file:line` | allowed only over its own record — the check includes the owner or the tenant |
| `client-only` `file:line` | hidden in the interface, endpoint unchecked on the server |
| `?` | you did not find where it is decided |

`?` is a valid result and the most important one in the table. **Never fill a cell by inference** — not from the role's name, not from what "makes sense", not from the neighbouring route. If you did not find the line, the cell is `?` and it goes into the report as not verified.

## Severity

**CRITICAL** = someone reaches data or an action that is not theirs, and you can describe how.
**HIGH** = the check exists but is inconsistent, bypassable, or contradicts another source.
**NOTE** = untidiness with no path you can describe.

## 4. What to report beyond the matrix

| # | Checks | Sev |
|---|-------|-----|
| R1 | Permission enforced only in the frontend — endpoint answers a direct call | CRITICAL |
| R2 | Role read from the body, query, header or localStorage instead of the server-verified token | CRITICAL |
| R3 | Check passes on the role but ignores the owner/tenant — right role, someone else's row | CRITICAL |
| R4 | Endpoint that writes the `role`/`permissions` field reachable by the role itself — privilege escalation | CRITICAL |
| R5 | Route with no check inside a group where every sibling has one | HIGH |
| R6 | `admin`/wildcard bypass that short-circuits the check before any rule runs | HIGH |
| R7 | Two sources disagreeing — code enum, database table and IdP saying different things | HIGH |
| R8 | Permission declared and never checked anywhere | NOTE |
| R9 | Role declared and never used in any check | NOTE |

## Before reporting

1. **Look for the defense before saying it is missing.** A global middleware, a base controller, a gateway rule may already cover it. Could not find where to look? Write that — do not assert absence.
2. **Confirm the code runs.** Tests, seeds, mocks and dead code do not go into the matrix as production cells.
3. **Describe the path for every CRITICAL.** Who, what they send, what they get back. Cannot write it in one sentence? It is a NOTE.

## Report

**Write it to a `.md` file.** Path: `rbac.md` at the target's root, or the path the user indicates. If a file with that name already exists, ask before overwriting. One line goes in the chat: the verdict and the file path.

First line of the file: the verdict in one sentence — how many roles, how many resources, how many cells came out `?`, and how many CRITICALs.

Then, in order:

1. **Roles**, **Resources** and **Actions** — the three lists from step 1, each item with `file:line`.
2. **The matrix**, split by resource group when it does not fit in one table.
3. **Findings**:

| ID | Sev | File:line | Rule | Finding | Path | What changes |
|----|-----|-----------|------|---------|------|--------------|
| RBAC-01 | CRITICAL | `api/users.ts:48` | R4 | `PATCH /users/:id` accepts `role` in the payload | any logged-in user sets their own `role` to `admin` in a single request | remove `role` from the accepted fields and give it its own endpoint restricted to `admin` |

**ID** is `RBAC-01`, `RBAC-02`, … in the order they appear. No gaps, no repeats — it is how the user will refer to the item later.

4. **NOT VERIFIED** — every `?` cell, plus what lives outside the repository (database, IdP, gateway) and what you could not read.

Report rules:
- **Always `file:line`.** A cell or a finding without a line does not go in — it goes to NOT VERIFIED.
- **The path is concrete**, not a category. "May allow escalation" is not a path.
- **"What changes" is actionable**: what gets done instead, and where.
- **A matrix full of `?` is a valid result.** Say so and stop. Do not fill it to look complete.
- If the target is large and you only covered part of it, say which part was left out.

## Final summary table

The file **always** ends with this table — every finding, one per row, in the same order and with the same ID:

| ID | Sev | Item | Where |
|----|-----|------|-------|
| RBAC-01 | CRITICAL | user promotes themselves to admin | `api/users.ts:48` |

One row per finding, not one more — no matrix, no NOT VERIFIED, no recommendations. "Item" is the finding in up to 10 words.

Zero findings: the table still goes in, with a single row reading `no findings`.
