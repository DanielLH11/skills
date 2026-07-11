---
name: flow
description: Chain a curated prompt into an open PR - acquire a treehouse worktree on a branch derived from the prompt, run /to-spec then /to-tickets, implement, and gate-and-push via /no-mistakes. Use when the user invokes /flow, asks to "ship a feature end-to-end", or wants to chain spec → tickets → implementation in one step.
---

# Flow

Chain a feature from a prompt to an open PR: **treehouse worktree → /to-spec → /to-tickets → implement → gate & push (/no-mistakes)**. The branch name is derived from the prompt using [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) types as a `<type>/<slug>` prefix; commits carry a Jira key only when one is supplied.

## Invocation

`/flow [--jira <KEY>] <prompt>`

- `--jira <KEY>` (optional, anywhere in the args): prefix every commit subject with `<KEY>`. If absent, omit it - never ask for one. The key belongs in commit subjects **only** - it never appears in the branch name.
- Everything else, with the `--jira <KEY>` flag and its value removed, is the curated feature prompt. Strip the flag out **first**, then treat what remains as `prompt`.

## Run

1. **Preflight** - if `prompt` is empty, **STOP** with the usage line. Derive `branch_name` as `<type>/<slug>`:
   - `<type>` is the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) type that best fits the prompt - one of `feat`, `fix`, `build`, `chore`, `ci`, `docs`, `style`, `refactor`, `perf`, `test`. Default to `feat` when unclear.
   - `<slug>` is the **prompt** slugified - the feature description only, after the `--jira <KEY>` flag and value have been stripped: lowercase, non-alphanumerics → single dash, trim/collapse dashes, ≤48 chars; fall back to `<UTC yyyymmdd-hhmmss>` if empty. The branch name is derived purely from the standard type and the content of the change; a Jira key (e.g. `ABC-123`) must never survive into `<slug>`.
   - Always join with a forward slash (e.g. `feat/add-login`, `fix/null-crash`). Announce the branch name.
2. **Worktree** - acquire an isolated [treehouse](https://github.com/kunchenguid/treehouse) worktree and branch off it:
   ```sh
   wt="$(treehouse get --lease --lease-holder "flow:<branch_name>")"
   git -C "$wt" switch -c <branch_name>
   ```
   `--lease` is required; never run bare `treehouse`/`treehouse get` (the interactive subshell hangs the run). If acquisition fails, **STOP** - no fallback to the main checkout. treehouse moves only the shell cwd, not the session, so treat `$wt` as the operating root: run every command and resolve every file path under it. STOP if `<branch_name>` already exists.
3. **Spec** - invoke `to-spec` with the prompt; capture the spec reference.
4. **Tickets** - invoke `to-tickets` against that spec; capture the created tickets.
5. **Implement** - work the tickets in order, committing each under `$wt` with a message referencing it: `<KEY> fix #<id>: <title>` when a Jira key is set, else `fix #<id>: <title>`. No `Co-Authored-By` / Claude attribution; honor hooks (fix and re-commit, never `--amend` / `--no-verify`).
6. **Gate & push** - invoke `no-mistakes` with `prompt` as the `--intent` to validate, push, open the PR, and watch CI.
   - `checks-passed` / `passed` → return the worktree: `treehouse return --force "$wt"` then `git -C "$wt" branch -D <branch_name> 2>/dev/null || true`.
   - `failed` / `cancelled` (or no push) → **STOP**; leave the worktree leased (parked) so nothing is lost.
