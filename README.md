# Agent Skills

A personal collection of agent skills that extend capabilities across planning, development, and tooling.

> Based on [Matt Pocock's skills](https://github.com/mattpocock/skills), with additional custom skills and modifications by Daniel Las Heras.

## Global CLAUDE.md

My personal global `CLAUDE.md` (behavioral guidelines for Claude Code) is available at [`examples/CLAUDE.md`](examples/CLAUDE.md) — copy it to `~/.claude/CLAUDE.md` if you want to use it.

## Repository layout

Editable skill **sources** live under category folders, mirroring the upstream repo:

```
engineering/   productivity/   misc/
└── <skill>/SKILL.md ...
```

Claude Code only discovers a skill when its `SKILL.md` is a **direct child** of `~/.claude/skills/` — it does *not* scan category subfolders. So `sync.ps1` flattens each `<category>/<skill>/` into a top-level `<skill>/` copy that Claude reads. Those flat copies are **generated artifacts** and are gitignored.

### Installing / syncing

This repo is meant to *be* your `~/.claude/skills/` directory. After cloning it there, or after editing any skill source, regenerate the flat copies:

```powershell
./sync.ps1
```

**Always edit the source under `engineering/ productivity/ misc/`, never the top-level flat copy** (it gets overwritten on the next sync). Run `/pull-skills` to sync from upstream — it writes into the category sources and re-runs `sync.ps1` automatically.

## Planning & Design

These skills help you think through problems before writing code.

- **to-prd** — Turn the current conversation context into a PRD and submit it as a GitHub issue. No interview — just synthesizes what you've already discussed.

  ```
  npx skills@latest add mattpocock/skills/to-prd
  ```

- **to-issues** — Break any plan, spec, or PRD into independently-grabbable GitHub issues using vertical slices.

  ```
  npx skills@latest add mattpocock/skills/to-issues
  ```

- **grill-me** — Get relentlessly interviewed about a plan or design until every branch of the decision tree is resolved.

  ```
  npx skills@latest add mattpocock/skills/grill-me
  ```

- **design-an-interface** — Generate multiple radically different interface designs for a module using parallel sub-agents.

  ```
  npx skills@latest add mattpocock/skills/design-an-interface
  ```

- **request-refactor-plan** — Create a detailed refactor plan with tiny commits via user interview, then file it as a GitHub issue.

  ```
  npx skills@latest add mattpocock/skills/request-refactor-plan
  ```

## Development

These skills help you write, refactor, and fix code.

- **tdd** — Test-driven development with a red-green-refactor loop. Builds features or fixes bugs one vertical slice at a time.

  ```
  npx skills@latest add mattpocock/skills/tdd
  ```

- **triage-issue** — Investigate a bug by exploring the codebase, identify the root cause, and file a GitHub issue with a TDD-based fix plan.

  ```
  npx skills@latest add mattpocock/skills/triage-issue
  ```

- **improve-codebase-architecture** — Find deepening opportunities in a codebase, informed by the domain language in `CONTEXT.md` and the decisions in `docs/adr/`.

  ```
  npx skills@latest add mattpocock/skills/improve-codebase-architecture
  ```

- **migrate-to-shoehorn** — Migrate test files from `as` type assertions to @total-typescript/shoehorn.

  ```
  npx skills@latest add mattpocock/skills/migrate-to-shoehorn
  ```

- **scaffold-exercises** — Create exercise directory structures with sections, problems, solutions, and explainers.

  ```
  npx skills@latest add mattpocock/skills/scaffold-exercises
  ```

## Tooling & Setup

- **setup-pre-commit** — Set up Husky pre-commit hooks with lint-staged, Prettier, type checking, and tests.

  ```
  npx skills@latest add mattpocock/skills/setup-pre-commit
  ```

- **git-guardrails-claude-code** — Set up Claude Code hooks to block dangerous git commands (push, reset --hard, clean, etc.) before they execute.

  ```
  npx skills@latest add mattpocock/skills/git-guardrails-claude-code
  ```

## Writing & Knowledge

- **write-a-skill** — Create new skills with proper structure, progressive disclosure, and bundled resources.

  ```
  npx skills@latest add mattpocock/skills/write-a-skill
  ```

- **edit-article** — Edit and improve articles by restructuring sections, improving clarity, and tightening prose.

  ```
  npx skills@latest add mattpocock/skills/edit-article
  ```

- **ubiquitous-language** — Extract a DDD-style ubiquitous language glossary from the current conversation.

  ```
  npx skills@latest add mattpocock/skills/ubiquitous-language
  ```

- **obsidian-vault** — Search, create, and manage notes in an Obsidian vault with wikilinks and index notes.

  ```
  npx skills@latest add mattpocock/skills/obsidian-vault
  ```
