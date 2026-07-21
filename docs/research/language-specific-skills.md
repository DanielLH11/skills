# Should a skills repository contain per-programming-language skills?

Research date: 2026-07-21.
Question: is adding language-specific skills (Python, TypeScript, Java, CSS, ...) to this repository a good practice, based on how experienced engineers actually organize agent skills?

## Verdict up front

Pure per-language "knowledge dump" skills (a catch-all `python-skill` or `typescript-expert`) are an anti-pattern.
Narrowly-scoped, task-oriented skills *within* a language (testing patterns for Python, advanced types for TypeScript) are worthwhile when they match the stack you actually work in.
This repository adds the latter kind, sourced from proven high-install skills on skills.sh.

## How skill selection actually works

Claude Code loads a skill when the model judges that the *task* matches the skill description, not when it detects a language in the repo.
Hanchung Lee's [first-principles deep dive](https://leehanchung.github.io/blogs/2025/10/26/claude-skills-deep-dive/) describes skills as prompt-based execution-context modifiers selected by task match.
A skill named after a language gives the selector almost nothing to match on: every Python task "matches" it, so it either fires constantly (token cost on every task) or gets ignored.
A skill named after a task class ("python-testing-patterns") fires exactly when that work comes up.

## What the ecosystem does

The consistent pattern across real-world skill collections is workflow-first organization:

- [Agent Skill Control Theory](https://github.com/DBvc/agent-skill-control-theory) defines a skill as "a selectively loaded control layer that changes how an LLM agent behaves on a recurring class of tasks".
- Real-world repos such as [AnastasiyaW/claude-code-config](https://github.com/AnastasiyaW/claude-code-config) organize ~30 skills by workflow (`frontend-design`, `code review`), and where a language appears it is scoped to a task (SQL query *optimization*, not SQL).
- Anthropic's own authoring guidance emphasizes descriptions that state what the skill does and when to use it, which a bare language name cannot express.
- The highest-install skills on [skills.sh](https://vercel.com/docs/agent-resources/skills) that mention a language are all task-scoped: `typescript-advanced-types` (54.7K installs), `python-testing-patterns` (27.8K), `java-springboot` (18.2K).
- Community roundups such as [The 10 Claude Code Skills I Actually Use at Work](https://www.welcomedeveloper.com/posts/the-10-claude-code-skills/) feature workflow and stack-pattern skills (e.g. Vercel's `react-best-practices`), never language catch-alls.

The reasoning behind the pattern: models already know programming languages natively.
What they lack is your process, your conventions, and hard-won edge-case knowledge for specific recurring tasks.

## The research caution

Skills are not free.
An evaluation across 8 models ([arXiv 2604.03088](https://arxiv.org/pdf/2604.03088)) found that enabling skills *degraded* performance on about 15% of tasks, and that bloated workflow-style skills added up to 451% token overhead with no pass-rate gain.
The failure mode is exactly the broad knowledge-dump skill: large, always-plausibly-relevant, and redundant with what the model already knows.
The implication is to keep every skill tightly scoped and to prefer a small curated set over broad coverage.

## Conclusion for this repository

- Do not add catch-all language skills (`python-pro`, `typescript-expert` and similar were deliberately skipped).
- Do add task-scoped language skills that match the actual working stack: TypeScript/React/Next.js, JavaScript, Python, Java, HTML, CSS.
- Source generic-but-proven task skills externally via the [Vercel skills CLI](https://github.com/vercel-labs/skills) (`npx skills find` / `npx skills add`), using install counts and reputable owners as the quality filter.
- Encode team-specific conventions as your own skills; that is the one place where "language" skills carry information the model cannot already have.

## What was added and why

All verified via `npx skills find` against the skills.sh directory on 2026-07-21.
Install counts are the quality signal recommended by Vercel's own `find-skills` meta-skill (prefer 1K+ installs and reputable owners).

| Skill | Source | Installs | Rationale |
| --- | --- | --- | --- |
| typescript-advanced-types | wshobson/agents | 54.7K | Task-scoped TS type-level work; complements existing React skills |
| python-testing-patterns | wshobson/agents | 27.8K | Testing is the highest-value task scope for Python work |
| python-design-patterns | wshobson/agents | 16.9K | Structural guidance for larger Python codebases |
| javascript-typescript-jest | github/awesome-copilot | 11.8K | JS/TS test authoring conventions |
| java-springboot | github/awesome-copilot | 18.2K | The dominant Java task context |
| java-junit | github/awesome-copilot | 10.8K | Java testing conventions |
| tailwind-css-patterns | giuseppe-trisciuoglio/developer-kit | 13.7K | Task-scoped CSS utility patterns |

Deliberately not added:

- Generic language catch-alls (`typescript-expert`, `python-pro`): the researched anti-pattern.
- `css-animations` (heygen-com/hyperframes, 73.1K installs): on inspection it is a single adapter file inside a 121-file video-animation toolkit, not a standalone CSS skill, so installing it would drag in a large unrelated instruction set.
- React skills: already covered by `react-best-practices` and `composition-patterns`.
- HTML-only skills: covered by `web-design-guidelines` and the existing frontend workflow skills.
