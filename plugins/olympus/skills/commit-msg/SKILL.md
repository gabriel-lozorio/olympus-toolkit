---
name: commit-msg
description: Reads the diff and returns ONLY the commit message text, in the repository's own convention. Never runs git that alters the repo — no add, commit, push, nothing. Use when asked for a commit message.
disallowed-tools: Edit Write NotebookEdit
---

You write the commit message. **You do not commit.** The deliverable is the text, for the user to copy.

Respond in the language the user wrote in. The commit message itself follows the repository's language, not the user's.

## Repository state, captured when the skill loaded

Use this instead of re-running these commands.

- Branch: !`git branch --show-current`
- Last commits: !`git log --oneline -20`
- Staged diff: !`git diff --staged`
- Working-tree diff: !`git diff`

## Git: what is allowed and what is not

**Allowed** (read-only, and only what is needed): `git diff`, `git diff --staged`, `git status`, `git log`, `git branch`.

**Never, under any circumstance:** `add`, `commit`, `push`, `checkout`, `branch`, `reset`, `stash`, `rebase`, `merge`, `tag` — not "to make it easier", not once the text is ready, not even when it looks obvious that is what the user wanted. If they want to commit, they will ask.

## How to run

1. **Pick the target:** if anything is staged, the message covers what is staged (`git diff --staged`). If nothing is, it covers the working tree (`git diff`). Say which of the two you used.
2. **Read the whole diff** — not just the file names. The message describes what actually changed, not what the file name suggests.
3. **Find the repo's convention:** `git log --oneline -20`. Copy what is there — Conventional Commits or not, language, use of scope, trailers (`Co-Authored-By`, ticket). The repository's convention governs; do not impose your own.
4. **Check which branch you are on:** `git branch --show-current`.
   - Already on a working branch → the message only.
   - On the main branch (`main`/`master`) → also suggest a branch name, in the fixed pattern below.

   | What the diff does | Branch |
   |---|---|
   | new feature | `dev/gabriel/<topic>` |
   | bug fix | `fix/gabriel/<topic>` |
   | refactor | `refat/gabriel/<topic>` |

   `<topic>` is short, lowercase, unaccented, derived from what the diff does — in the style of `dev/gabriel/promocao`.
5. Write the message and deliver.

## The message

- **Subject**: one line, imperative mood, up to ~72 characters, no trailing period. States **what the commit does**, not which files it touched.
- **Body**: only if the *why* is not obvious from the subject — reason, constraint, decision. Lines up to ~72 columns, separated from the subject by a blank line. No body is a normal outcome.
- **Never invent**: do not write a reason, ticket, breaking change or impact that the diff does not show and the user did not state. With no source, the fact stays out.
- **Trailers** only if the repo's `git log` shows it uses them.

## Delivery

Only the text, in a code block, ready to copy. No preamble, no explaining your choices, no offering to commit.

On the main branch, the suggested branch name goes in its own block, before the message, labeled `branch:`. The name only — do not create the branch, do not run `checkout -b`.

Two exceptions — one line before the block:
- The diff was empty (nothing staged / clean working tree): say so and stop.
- The diff mixes **unrelated** changes: say in one sentence which groups you saw and suggest splitting into separate commits. Then deliver the message for the whole set anyway — splitting is the user's call.
