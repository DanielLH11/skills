# Agent Skills

A personal collection of agent skills that extend capabilities across planning, development, and tooling.

> Based on [Matt Pocock's skills](https://github.com/mattpocock/skills), with additional custom skills and modifications by Daniel Las Heras.
>
> The **marketing** skills are from [Alireza Rezvani's claude-skills](https://github.com/alirezarezvani/claude-skills) (MIT licensed) — full credit to the original creator. See [Marketing](#marketing) below.

## Global CLAUDE.md

My personal global `CLAUDE.md` (behavioral guidelines for Claude Code) is available at [`examples/CLAUDE.md`](examples/CLAUDE.md) — copy it to `~/.claude/CLAUDE.md` if you want to use it.

## Repository layout

Editable skill **sources** live under category folders, mirroring the upstream repo:

```
engineering/   productivity/   misc/   marketing/
└── <skill>/SKILL.md ...
```

Claude Code only discovers a skill when its `SKILL.md` is a **direct child** of `~/.claude/skills/` — it does *not* scan category subfolders. So `sync.ps1` flattens each `<category>/<skill>/` into a top-level `<skill>/` copy that Claude reads. Those flat copies are **generated artifacts** and are gitignored.

### Installing / syncing

This repo is meant to *be* your `~/.claude/skills/` directory. After cloning it there, or after editing any skill source, regenerate the flat copies:

```powershell
./sync.ps1
```

**Always edit the source under `engineering/ productivity/ misc/ marketing/`, never the top-level flat copy** (it gets overwritten on the next sync). Run `/pull-skills` to sync from upstream — it writes into the category sources and re-runs `sync.ps1` automatically.

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
