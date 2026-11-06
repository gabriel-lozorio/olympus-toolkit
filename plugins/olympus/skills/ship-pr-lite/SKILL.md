---
name: ship-pr-lite
description: Creates the branch if needed, commits, pushes, opens the PR, then posts a PR comment describing what was done — no screenshots or video. Use only when the user runs /ship-pr-lite.
disable-model-invocation: true
---

You take the current change all the way to a PR with a comment describing what was done. Running this skill **is** the user's request for every git and `gh` action listed below — and only those.

Respond in the language the user wrote in. The commit message, the PR and the comment follow the repository's language.

## Git: what is allowed

**Allowed:** `git status`, `git diff`, `git log`, `git branch --show-current`, `git checkout -b`, `git add`, `git commit`, `git push -u origin <branch>`, `gh pr view`, `gh pr create`, `gh pr comment`.

**Never:** `reset`, `rebase`, `merge`, `stash`, `tag`, `push --force`, `--no-verify`, amending a commit.

## 1. Branch

`git branch --show-current`.

- Already on a working branch → use it.
- On the main branch (`main`/`master`) → create one with `git checkout -b`, in the fixed pattern:

| What the diff does | Branch |
|---|---|
| new feature | `dev/gabriel/<topic>` |
| bug fix | `fix/gabriel/<topic>` |
| refactor | `refat/gabriel/<topic>` |

`<topic>` is short, lowercase, unaccented, derived from what the diff does.

## 2. Commit

1. **Target:** if anything is staged, commit only what is staged. If nothing is, `git add` the working-tree changes by name — never a file that looks like a secret (`.env`, keys, credentials); list any you left out.
2. **Read the whole diff.** If it mixes **unrelated** changes, stop and ask which go in this PR.
3. **Message:** follow the repo's convention from `git log --oneline -20` (language, Conventional Commits or not, scope, trailers). Subject in the imperative, up to ~72 characters, saying what the commit does. Body only when the *why* is not obvious. Never invent a reason, ticket or impact the diff does not show.
4. Clean working tree and nothing new to commit → skip to the push.

## 3. Push and PR

1. `git push -u origin <branch>`.
2. `gh pr view` — if the branch already has an open PR, use it and go to step 4.
3. `gh pr create` with a title (the commit subject when there is one commit) and a body describing what changed, read from the diff — no claim the diff does not support.

## 4. Comment on the PR

Write the body to a file in the scratchpad and post:

```
gh pr comment <n> --body-file <body.md>
```

Body, read from the diff of the PR's commits:

- one line: what the change does;
- what was done, as a list — one item per change, citing the file;
- nothing the diff does not show: no reason, test or impact that was not in it.

No screenshots, no video, no browser.

## Delivery

In the chat: the branch, the commit subject, the PR link and the comment link. If something was skipped — files left out of the commit — one line per item saying what and why.
