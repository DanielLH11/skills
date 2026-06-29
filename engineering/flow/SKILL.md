---
name: flow
description: Chain a curated prompt into an open PR - acquire a treehouse worktree on a branch derived from the prompt, run /to-prd then /to-issues, implement, and gate-and-push via /no-mistakes. Use when the user invokes /flow, asks to "ship a feature end-to-end", or wants to chain PRD → issues → implementation in one step.
---

# Flow

Chain a feature from a prompt to an open PR: **treehouse worktree → /to-prd → /to-issues → implement → gate & push (/no-mistakes)**. The branch name is derived from the prompt; commits carry a Jira key only when one is supplied.

## Invocation

`/flow [--jira <KEY>] <prompt>`

- `--jira <KEY>` (optional, anywhere in the args): prefix every commit subject with `<KEY>`. If absent, omit it - never ask for one.
- Everything else is the curated feature prompt.

## Run

1. **Preflight** - if `prompt` is empty, **STOP** with the usage line. Derive `branch_name` by slugifying the prompt (lowercase, non-alphanumerics → single dash, trim/collapse dashes, ≤48 chars; fall back to `flow-<UTC yyyymmdd-hhmmss>` if empty). Announce it.
2. **Worktree** - acquire an isolated [treehouse](https://github.com/kunchenguid/treehouse) worktree and branch off it:
   ```sh
   wt="$(treehouse get --lease --lease-holder "flow:<branch_name>")"
   git -C "$wt" switch -c <branch_name>
   ```
   `--lease` is required; never run bare `treehouse`/`treehouse get` (the interactive subshell hangs the run). If acquisition fails, **STOP** - no fallback to the main checkout. treehouse moves only the shell cwd, not the session, so treat `$wt` as the operating root: run every command and resolve every file path under it. STOP if `<branch_name>` already exists.
3. **PRD** - invoke `to-prd` with the prompt; capture the PRD reference.
4. **Issues** - invoke `to-issues` against that PRD; capture the created issues.
5. **Implement** - work the issues in order, committing each under `$wt` with a message referencing it: `<KEY> fix #<id>: <title>` when a Jira key is set, else `fix #<id>: <title>`. No `Co-Authored-By` / Claude attribution; honor hooks (fix and re-commit, never `--amend` / `--no-verify`).
6. **Gate & push** - invoke `no-mistakes` with `prompt` as the `--intent` to validate, push, open the PR, and watch CI.
   - `checks-passed` / `passed` → return the worktree: `treehouse return --force "$wt"` then `git -C "$wt" branch -D <branch_name> 2>/dev/null || true`.
   - `failed` / `cancelled` (or no push) → **STOP**; leave the worktree leased (parked) so nothing is lost.
