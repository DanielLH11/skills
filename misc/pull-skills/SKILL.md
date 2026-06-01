---
name: pull-skills
description: Sync local skills against the upstream mattpocock/skills repo — compare folders engineering, productivity, misc, surface diffs, and update only after the user confirms each change. Use when the user invokes /pull-skills, asks to "update Matt Pocock skills", "sync skills", or "check for skill updates".
---

# Pull Skills

Upstream: `https://github.com/mattpocock/skills` (branch `main`).
Local skills root: `C:\Users\PcVIP\.claude\skills`.

> **Layout note.** This repo keeps the editable skill **sources** under category folders — `engineering/<skill>/`, `productivity/<skill>/`, `misc/<skill>/` — mirroring upstream's layout. The top-level `<skill>/` folders are **generated flat copies** (gitignored) that `sync.ps1` produces for Claude Code discovery. **Always read/write the category source, never the flat copy**, then run `sync.ps1`.

## Sync scope

- **Pull from**: `engineering/`, `productivity/`, `misc/`
- **Ignore**: `personal/`, `in-progress/`
- **Deletion source**: `deprecated/` — if a local skill name matches a source folder, propose removing it.
- **Preserve**: any local skill **not present upstream** (e.g. user-authored skills like `flow`, `pull-skills`). Never touch these.

## Workflow

1. **Fetch upstream.** Shallow-clone (or `git pull` if cached) to a temp dir:
   `git clone --depth=1 https://github.com/mattpocock/skills <temp>` (reuse if already cloned; `git -C <temp> pull --ff-only`).
2. **Enumerate upstream skills.** For each folder in scope, list immediate subdirectories — each is a skill.
3. **Diff each skill** against the local **source** `C:\Users\PcVIP\.claude\skills\<category>\<skill>` (same category as upstream — `engineering`/`productivity`/`misc`):
   - **Missing locally** → propose ADD (into the matching category folder).
   - **Exists locally, content differs** (compare all files, primarily `SKILL.md`) → show unified diff, propose UPDATE.
   - **Exists locally, identical** → skip silently.
   - If a skill of the same name exists under a *different* local category than upstream places it, do not duplicate it — flag the mismatch and ask the user which category wins.
4. **Deprecations.** For each subdir in upstream `deprecated/`, if a local source skill of the same name exists, propose DELETE.
5. **Confirm per skill.** Present a summary table (skill | action | one-line reason), then ask the user to approve. For UPDATEs, show the diff first. Apply only what's confirmed.
6. **Apply changes** to the **category source** (never the top-level flat copy): copy the upstream skill directory over `<category>\<skill>` (full replace) for ADD/UPDATE; `rm -rf` `<category>\<skill>` for DELETE.
7. **Regenerate flat copies.** Run `sync.ps1` from the skills root so the changes reach the top-level folders Claude Code reads. (For a DELETE, also remove the now-orphaned top-level flat copy, since `sync.ps1` only ever overwrites — it does not prune.)
8. **Report.** List applied / skipped / preserved counts. Surface any upstream skills whose names collide with a user-authored local skill — never overwrite, just flag.

## Guardrails

- Never modify a local skill that isn't in the upstream scope folders.
- Never delete a local skill unless it appears under upstream `deprecated/` **and** the user confirms.
- Treat the temp clone as read-only; do not commit anything to it.
- If `git`/network fails, stop and report — do not partially sync.
- Do not auto-run; always show the plan and wait for approval before writing.
