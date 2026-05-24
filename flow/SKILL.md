---
name: flow
description: Run the full feature pipeline from a curated prompt — create a worktree, generate a PRD, break it into tracker issues, then start implementing them. Use when the user invokes /flow, asks to "ship a feature end-to-end", or wants to chain PRD → issues → implementation in one step.
---

# Flow

Pipeline: **worktree → curated prompt → /to-prd → /to-issues → implement issues**.

## Invocation

`/flow <branch-name> <prompt>`

- The first whitespace-separated token in `$ARGUMENTS` is the **branch name**.
- Everything after it is the **curated feature prompt**.

## Preflight (abort on failure)

1. Parse `$ARGUMENTS`:
   - `branch_name` = first whitespace-separated token.
   - `prompt` = the remainder (trim leading whitespace).
2. If `branch_name` is missing/empty: **STOP**. Tell the user the correct usage is `/flow <branch-name> <prompt>` and do not run any further steps.
3. If `prompt` is missing/empty: **STOP**. Tell the user a curated prompt is required after the branch name and do not run any further steps.
4. Validate `branch_name`: each `/`-separated segment must contain only letters, digits, dots, underscores, and dashes; max 64 chars total. If invalid, **STOP** and tell the user.

## Create the worktree (always)

1. Load the `EnterWorktree` tool via `ToolSearch` if it is not already available (`select:EnterWorktree`).
2. Call `EnterWorktree` with `name: <branch_name>`. This creates an isolated worktree and switches the session into it.
3. If `EnterWorktree` fails (already inside a worktree, name conflict, etc.), **STOP** and surface the error — do not fall back to running the pipeline on the original branch.

All subsequent steps run **inside** the new worktree.

## Steps

1. **PRD** — invoke the `to-prd` skill with the curated prompt as context. Let it publish to the issue tracker (full pipeline). Capture the resulting PRD reference (issue URL / ID).
2. **Issues** — invoke the `to-issues` skill against that PRD. Let it create the sub-issues on the tracker. Capture the full list of created issue titles and IDs.
3. **Implement** — work through the issues in order, one at a time:
   - Read the issue title and description.
   - Implement the changes required to satisfy the issue.
   - Commit the changes with a message referencing the issue (e.g. `fix #<id>: <title>`). **Do not include the `Co-Authored-By: Claude` trailer or any Anthropic attribution.** Use a plain HEREDOC body.
   - Move to the next issue.
4. Report: worktree path, branch name, PRD link, issue links, implementation summary.

## Commit rules

- No `Co-Authored-By:` lines.
- No "🤖 Generated with Claude Code" footer.
- Honor pre-commit hooks; if a hook fails, fix and create a **new** commit (do not `--amend`, do not `--no-verify`).

## Guardrails

- Never run the pipeline without first entering a worktree. If worktree creation fails, abort.
- If `to-prd` or `to-issues` fails, stop and surface the error — do not start implementation on a partial state.
- Do not push the branch or open a PR unless the user asks.
- Do not call `ExitWorktree` automatically — leave the worktree intact for the user.
