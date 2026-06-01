---
name: flow
description: Run the full feature pipeline from a curated prompt — create a worktree on a named git branch, generate a PRD, break it into tracker issues, implement them, commit, push the branch, then remove the worktree. Use when the user invokes /flow, asks to "ship a feature end-to-end", or wants to chain PRD → issues → implementation in one step.
---

# Flow

Pipeline: **worktree (named branch) → curated prompt → /to-prd → /to-issues → implement → commit → push → remove worktree**.

The commits live on the pushed branch, so the worktree is safe to remove afterward — the work is reviewed from the branch/commits on the remote.

## Invocation

`/flow <branch-name> [--jira <KEY>] <prompt>`

- The first whitespace-separated token in `$ARGUMENTS` is the **branch name**.
- An optional `--jira <KEY>` flag (anywhere in the arguments) sets the **Jira task** to embed in commit messages.
- Everything else is the **curated feature prompt**.

## Preflight (abort on failure)

1. Parse `$ARGUMENTS`:
   - Extract the optional `--jira <KEY>` flag (and its value) wherever it appears, and remove both tokens from the arguments.
   - `branch_name` = first remaining whitespace-separated token.
   - `prompt` = the remainder (trim leading whitespace).
   - `jira_key` = the `--jira` value, or empty if not provided.
2. If `branch_name` is missing/empty: **STOP**. Tell the user the correct usage is `/flow <branch-name> [--jira <KEY>] <prompt>` and do not run any further steps.
3. If `prompt` is missing/empty: **STOP**. Tell the user a curated prompt is required after the branch name and do not run any further steps.
4. Validate `branch_name`: each `/`-separated segment must contain only letters, digits, dots, underscores, and dashes; max 64 chars total. If invalid, **STOP** and tell the user.
5. If `jira_key` is present, validate it looks like a Jira key (e.g. `ABC-123`: letters, digits, dashes). If it looks malformed, surface this and ask before continuing.

## Create the worktree (always)

1. Load the `EnterWorktree` tool via `ToolSearch` if it is not already available (`select:EnterWorktree`).
2. Call `EnterWorktree` with `name: <branch_name>`. This creates an isolated worktree on a new branch and switches the session into it.
3. If `EnterWorktree` fails (already inside a worktree, name conflict, etc.), **STOP** and surface the error — do not fall back to running the pipeline on the original branch.
4. Ensure the branch is named exactly `branch_name`. Run `git rev-parse --abbrev-ref HEAD`; if it differs from `branch_name`, rename it with `git branch -m <branch_name>`. If the rename fails, **STOP** and surface the error.

All subsequent steps run **inside** the new worktree.

## Steps

1. **PRD** — invoke the `to-prd` skill with the curated prompt as context. Let it publish to the issue tracker (full pipeline). Capture the resulting PRD reference (issue URL / ID).
2. **Issues** — invoke the `to-issues` skill against that PRD. Let it create the sub-issues on the tracker. Capture the full list of created issue titles and IDs.
3. **Implement** — work through the issues in order, one at a time:
   - Read the issue title and description.
   - Implement the changes required to satisfy the issue.
   - Commit the changes with a message referencing the issue. If `jira_key` is set, prefix the subject with it: `<jira_key> fix #<id>: <title>`. Otherwise: `fix #<id>: <title>`. **Do not include the `Co-Authored-By: Claude` trailer or any Anthropic attribution.** Use a plain HEREDOC body.
   - Move to the next issue.
4. **Push** — push the branch to origin: `git push -u origin <branch_name>`. If the push fails, **STOP**: leave the worktree intact (do not remove it) and surface the error so no committed work is lost.
5. **Remove the worktree** — only after a successful push. Load `ExitWorktree` via `ToolSearch` if needed (`select:ExitWorktree`), then call it with `action: "remove"` and `discard_changes: true`. This is safe because every commit is already on the pushed remote branch. (The local branch is deleted with the worktree; review happens from the pushed branch.)
6. **Briefing** — give a short summary after the run:
   - Branch name (and that it was pushed to origin).
   - Jira task, if provided.
   - Each commit message created.
   - PRD link and issue links.
   - One-line implementation summary.

## Commit rules

- No `Co-Authored-By:` lines.
- No "🤖 Generated with Claude Code" footer.
- Honor pre-commit hooks; if a hook fails, fix and create a **new** commit (do not `--amend`, do not `--no-verify`).
- Prefix the subject with `<jira_key>` when a Jira task was provided.

## Guardrails

- Never run the pipeline without first entering a worktree. If worktree creation fails, abort.
- If `to-prd` or `to-issues` fails, stop and surface the error — do not start implementation on a partial state.
- **Push the branch before removing the worktree.** If the push fails, keep the worktree and stop — never remove a worktree with `discard_changes: true` unless the commits are confirmed on the remote.
- Do not open a PR unless the user asks.
