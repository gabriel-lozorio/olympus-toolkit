---
name: ship-pr
description: Creates the branch if needed, commits, pushes, opens the PR, then captures screenshots and video of the change with a browser driver (Playwright MCP, playwright-cli or agent-browser) and posts them as a PR comment. Use only when the user runs /ship-pr.
disable-model-invocation: true
allowed-tools: Bash(git status *) Bash(git diff *) Bash(git log *) Bash(git branch *) Bash(git checkout -b *) Bash(git add *) Bash(git commit *) Bash(git push -u origin *) Bash(gh pr view *) Bash(gh pr create *) Bash(gh pr comment *) Bash(command -v *) Bash(playwright-cli *) Bash(agent-browser *)
---

You take the current change all the way to a PR with visual evidence. Running this skill **is** the user's request for every git and `gh` action listed below — and only those.

Respond in the language the user wrote in. The commit message and the PR follow the repository's language.

## Repository state, captured when the skill loaded

Use this instead of re-running these commands.

- Branch: !`git branch --show-current`
- Status: !`git status --short`
- Last commits: !`git log --oneline -20`
- Staged diff: !`git diff --staged`
- Working-tree diff: !`git diff`

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

## 4. Evidence

Three browser drivers, in this order. Use the first one available; do not mix them in one capture.

| # | Driver | Available when |
|---|---|---|
| A | Playwright MCP tools (`browser_*`) | the `browser_*` tools are in your tool list |
| B | `playwright-cli` | `command -v playwright-cli` succeeds |
| C | `agent-browser` | `command -v agent-browser` succeeds |

None available → no capture. Say which were missing and stop after the PR.

Every file goes to `${CLAUDE_PLUGIN_DATA}/evidence` — never into the repository.

1. **What to show:** the behaviour the diff changes. If you cannot tell from the repo how to reach it — app URL, how to start it, test login — ask the user. Never guess a URL or credentials.
2. **No visible behaviour** (docs, config, back-end with no screen) → no capture. Say so and stop after the PR.
3. **Capture with A (MCP):**
   - `browser_navigate` to the starting page first, then `browser_start_video`.
   - Walk through the change with `browser_click`, `browser_type`, `browser_fill_form`, using `browser_snapshot` to find the elements.
   - `browser_take_screenshot` at each state worth showing — the result, and the "before" when it makes sense.
   - `browser_stop_video`, then `browser_close`.
   - **Never pass `filename`** to the screenshot or video tools: explicit names land in the repository. Without it the files go to the evidence folder outside the repo. Use the paths the tool results return.
4. **Capture with B (`playwright-cli`)** — prefix every call with `PLAYWRIGHT_MCP_OUTPUT_DIR="${CLAUDE_PLUGIN_DATA}/evidence"`, otherwise it writes a `.playwright-cli/` folder into the repository:
   - `playwright-cli open --browser=chromium <url>`, then `playwright-cli video-start "${CLAUDE_PLUGIN_DATA}/evidence/<name>.webm"`.
   - Walk through with `playwright-cli click <ref>`, `fill <ref> <text>`, `type <text>`, using `playwright-cli snapshot` to get the refs.
   - `playwright-cli screenshot` at each state worth showing — no `--filename`; use the path the output returns.
   - `playwright-cli video-stop`, then `playwright-cli close`.
5. **Capture with C (`agent-browser`):**
   - `agent-browser open <url>`, then `agent-browser record start "${CLAUDE_PLUGIN_DATA}/evidence/<name>.webm"`. Recording needs `ffmpeg`; if it fails, go on with screenshots only and say so.
   - Walk through with `agent-browser click @<ref>`, `fill @<ref> <text>`, using `agent-browser snapshot` to get the refs.
   - `agent-browser screenshot "${CLAUDE_PLUGIN_DATA}/evidence/<name>.png"` at each state worth showing.
   - `agent-browser record stop`, then `agent-browser close`.
6. **Look at every screenshot** before posting. One that does not show what it claims does not go in.

## 5. Comment on the PR

Write the body to a file in the scratchpad and post:

```
gh pr comment <n> --body-file <body.md> --attach <shot1.png> --attach <shot2.png> --attach <video.webm>
```

Body:

- one line: what was verified;
- the steps you took in the browser, numbered;
- each screenshot inline as `![what it shows](<path>)` — `gh` rewrites the reference to the uploaded asset;
- the video is appended by `gh` at the end of the body.

Never open GitHub in the browser to upload, and never ask the user to log in for it — `gh --attach` does it.

## Delivery

In the chat: the branch, the commit subject, the PR link and the comment link. If something was skipped — no evidence, files left out of the commit — one line per item saying what and why.
