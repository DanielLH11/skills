# Personal Claude Code Configuration

A personal collection of Claude Code skills, agents, and global instructions for planning, development, marketing, and tooling.

> Based on [Matt Pocock's skills](https://github.com/mattpocock/skills), with additional custom skills and modifications by Daniel Las Heras.
>
> The **marketing** skills are from [Alireza Rezvani's claude-skills](https://github.com/alirezarezvani/claude-skills) under the MIT license.
> Full credit belongs to the original creator.
> See [Marketing](#marketing) below.

## Repository layout

This repository is intended to be installed directly at `~/.claude/skills/` and acts as the source of truth for three configuration types.

| Canonical source | Live Claude Code location | Purpose |
| --- | --- | --- |
| [`AGENTS.md`](AGENTS.md) | `~/.claude/CLAUDE.md` | Global behavioral and model-routing instructions |
| [`agents/*.md`](agents/) | `~/.claude/agents/*.md` | Global custom agent definitions |
| `<category>/<skill>/` | `~/.claude/skills/<skill>/` | Global skill definitions |

Editable skill sources live under category folders:

```text
engineering/
productivity/
misc/
marketing/
languages/
└── <skill>/SKILL.md
```

Claude Code only discovers a skill when its `SKILL.md` is a direct child of `~/.claude/skills/`.
It does not scan the category subfolders used for organization in this repository.
`sync.ps1` therefore flattens each `<category>/<skill>/` into a generated top-level `<skill>/` copy.
Those flat copies are gitignored and must not be edited directly.

The repository's `AGENTS.md` is the canonical global instruction file.
The live `~/.claude/CLAUDE.md` is generated from it.
The definitions under `agents/` are canonical, while the same-named files under `~/.claude/agents/` are generated deployment copies.
The sync only overwrites agents with matching names and preserves unrelated live agent files.

### Installing and syncing

Clone the repository as `~/.claude/skills/`, then publish all canonical configuration to Claude Code's discovery paths:

```powershell
./sync.ps1
```

Run the same command after changing a skill source, an agent definition, or `AGENTS.md`.
Always edit canonical files in the repository rather than generated top-level skill folders or live files outside the repository.
Run `/pull-skills` to synchronize upstream skill sources and rerun `sync.ps1` automatically.

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

- **[write-dockerfile](misc/write-dockerfile/)** - Generate or improve a project Dockerfile using verified repository context and modern Docker build practices.

- **[write-compose](misc/write-compose/)** - Generate or improve minimal Docker Compose configuration using the current Compose Specification.

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

## Language & Stack

Task-scoped skills for specific languages and stacks, curated from high-install sources on [skills.sh](https://skills.sh).
Catch-all language skills are deliberately avoided.
See [docs/research/language-specific-skills.md](docs/research/language-specific-skills.md) for the research behind this policy.

- **[typescript-advanced-types](languages/typescript-advanced-types/)** - Generics, conditional types, mapped types, template literals, and utility types.

  ```
  npx skills add wshobson/agents@typescript-advanced-types
  ```

- **[javascript-typescript-jest](languages/javascript-typescript-jest/)** - JS/TS testing with Jest: mocking strategies, test structure, and common patterns.

  ```
  npx skills add github/awesome-copilot@javascript-typescript-jest
  ```

- **[python-testing-patterns](languages/python-testing-patterns/)** - pytest, fixtures, mocking, parameterization, and TDD practices.

  ```
  npx skills add wshobson/agents@python-testing-patterns
  ```

- **[python-design-patterns](languages/python-design-patterns/)** - KISS, separation of concerns, single responsibility, and composition over inheritance in Python.

  ```
  npx skills add wshobson/agents@python-design-patterns
  ```

- **[java-springboot](languages/java-springboot/)** - Spring Boot application best practices.

  ```
  npx skills add github/awesome-copilot@java-springboot
  ```

- **[java-junit](languages/java-junit/)** - JUnit 5 unit testing, including data-driven tests.

  ```
  npx skills add github/awesome-copilot@java-junit
  ```

- **[tailwind-css-patterns](languages/tailwind-css-patterns/)** - Utility-first styling: responsive design, flexbox, grid, typography, and design systems.

  ```
  npx skills add giuseppe-trisciuoglio/developer-kit@tailwind-css-patterns
  ```

## Marketing

A suite of 45 marketing skills covering content, SEO/AEO, CRO, paid ads, lifecycle, analytics, and product marketing.

> **Credit:** These skills are created by **[Alireza Rezvani](https://github.com/alirezarezvani/claude-skills)** and are included here under their MIT license. Sources live under [`marketing/`](marketing/). To install the full upstream suite directly:
>
> ```bash
> npx ai-agent-skills install alirezarezvani/claude-skills/marketing-skill
> ```

### Strategy & Ops

- **marketing-ops** — Central router for the marketing skill ecosystem; orchestrates multi-skill campaigns.
- **marketing-context** — Create and maintain the marketing context document every other marketing skill reads first.
- **marketing-skills** — Index/overview of the marketing skill collection and its pods.
- **marketing-ideas** — Generate marketing ideas, inspiration, and strategies for SaaS/software products.
- **marketing-psychology** — Apply psychological principles, mental models, and behavioral science to marketing.
- **marketing-strategy-pmm** — Product marketing: positioning, GTM strategy, competitive intelligence, and launches.
- **marketing-demand-acquisition** — Demand-gen campaigns, paid-spend optimization, SEO strategy, and partnerships.
- **launch-strategy** — Plan a product launch, feature announcement, or release strategy.
- **pricing-strategy** — Design and communicate SaaS pricing — tiers, value metrics, and price increases.
- **brand-guidelines** — Apply, document, and enforce brand guidelines.
- **competitor-alternatives** — Build competitor comparison / alternative pages for SEO and sales enablement.
- **prompt-engineer-toolkit** — Analyze and rewrite prompts; build reusable prompt templates for marketing.

### Content & Copy

- **copywriting** — Write, rewrite, or improve marketing copy for any page.
- **copy-editing** — Edit, review, and improve existing marketing copy.
- **content-strategy** — Plan a content strategy and decide what topics to cover.
- **content-production** — Full content production pipeline from topic to publish-ready piece.
- **content-humanizer** — Make AI-generated content sound genuinely human.
- **content-creator** — Deprecated redirect that routes legacy "content creator" requests to the right specialist.
- **social-content** — Create, schedule, and optimize social content across platforms.
- **social-media-manager** — Social strategy, content calendars, community management, and growth.
- **social-media-analyzer** — Analyze social campaign performance, engagement rates, and ROI.
- **x-twitter-growth** — Grow on X/Twitter: audience building, viral content, and engagement analysis.

### SEO & AEO

- **seo-audit** — Audit, review, and diagnose technical SEO issues.
- **ai-seo** — Optimize content to get cited by AI search engines (ChatGPT, Perplexity, AI Overviews, etc.).
- **aeo** — Answer Engine Optimization: optimize content to be cited by LLMs.
- **programmatic-seo** — Create SEO-driven pages at scale from templates and data.
- **schema-markup** — Implement, audit, and validate structured data (schema markup).
- **site-architecture** — Audit/plan website structure, URL hierarchy, navigation, and internal linking.

### Conversion (CRO)

- **page-cro** — Optimize conversions on any marketing page.
- **form-cro** — Optimize non-signup forms (lead capture, contact, demo request).
- **signup-flow-cro** — Optimize signup, registration, and trial activation flows.
- **onboarding-cro** — Optimize post-signup onboarding, activation, and time-to-value.
- **popup-cro** — Create and optimize popups, modals, overlays, and banners.
- **paywall-upgrade-cro** — Create and optimize in-app paywalls, upgrade screens, and feature gates.
- **app-store-optimization** — ASO: keyword research, competitor rankings, and metadata suggestions.
- **ab-test-setup** — Plan, design, and implement A/B tests and experiments.

### Demand, Ads & Lifecycle

- **paid-ads** — Run paid campaigns on Google, Meta, LinkedIn, X, and other platforms.
- **ad-creative** — Generate, iterate, and scale ad copy and creative.
- **cold-email** — Write and sequence B2B cold outreach emails.
- **email-sequence** — Build and optimize drip campaigns and lifecycle email flows.
- **referral-program** — Design, launch, and optimize referral/affiliate programs.
- **free-tool-strategy** — Build free tools for lead gen, SEO value, and brand awareness.
- **churn-prevention** — Reduce churn via cancel flows, save offers, exit surveys, and dunning.

### Analytics

- **analytics-tracking** — Set up, audit, and debug analytics (GA4, GTM, event taxonomy, conversion tracking).
- **campaign-analytics** — Multi-touch attribution, funnel conversion, and ROI analysis.
